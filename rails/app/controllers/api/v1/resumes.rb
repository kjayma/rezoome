module API
  module V1

    class Resumes < Grape::API
      require 'mongoid/grid_fs'
      require 'stringio'
      require 'geokit'
      require 'yomu'

      include API::V1::Defaults
      include Geokit::Geocoders

      resource :resumes do
        desc "Return a resume file in text"

        params do
          requires :id, type: String, desc: "ID of the resume"
        end

        get "textfiles/:id", root: "resume" do
          content_type 'txt'
          env['api.format'] = :txt

          #grid_fs = Mongoid::GridFs
          #grid_fs.get(permitted_params[:resume_grid_fs_id]).data
          Resume.find_by(:id => params[:id]).resume_text
        end

        desc "Return a resume file in binary"

        params do
          requires :resume_grid_fs_id, type: String, desc: "ID of the resume file"
          optional :filename, type: String, desc: "preferred filename"
          optional :extension, type: String, desc: "extension"
        end

        get "files/:resume_grid_fs_id", root: "resume" do
          case params[:extension]
          when 'pdf'
            content_type 'application/pdf'
          when 'doc'
            content_type 'application/msword'
          when 'docx'
            content_type 'application/vnd.openxmlformats-officedocument.wordprocessingml.document'
          else
            content_type 'application/octet-stream'
          end
          header['content-Disposition'] = "attachment; filename=#{permitted_params[:filename]}"
          env['api.format'] = :binary

          grid_fs = Mongoid::GridFs
          grid_fs.get(permitted_params[:resume_grid_fs_id]).data
        end

        desc "post a resume file in json base64"

        params do
          requires :id, type: String, desc: "ID of the resume"
          requires :file
        end

        post ":id/resume_content", root: "resume" do
          id = permitted_params[:id]
          content = permitted_params[:file]
          md5sum = Digest::MD5.hexdigest content.tempfile.to_s
          resume_text = Yomu.new(content.tempfile).text
          fake_file = content.tempfile
          extension = $1 if content.filename.match(/\.(.*)/)
          resume = Resume.find(id)
          if resume
            resume.other_resumes.create!(
              resume_text: resume_text,
              doctype: extension,
              filename: content.filename,
              md5sum: md5sum,
              last_update: Time.now,
              resume_grid_fs_id: API::V1::Resumes.grid_file_id(fake_file)
            )
          else
            Rails.logger.warn "error - resume not found, id: #{id}"
            "error"
          end
        end

        desc "delete a resume file"

        params do
          requires :id, type: String, desc: "ID of the resume"
          requires :other_resume_id, type: String, desc: "Other Resume Id"
        end

        delete ":id/other_resumes/:other_resume_id", root: "resumes" do
          id = permitted_params[:id]
          other_resume_id = permitted_params[:other_resume_id]
          resume = Resume.find(id)
          other_resume = resume.other_resumes.find(other_resume_id)
          other_resume.destroy
        end

        desc "delete a person"

        params do
          requires :id, type: String, desc: "ID of the resume"
        end

        delete ":id", root: "resumes" do
          id = permitted_params[:id]
          resume = Resume.find(id)
          resume.destroy!
        end

        desc "post a complete resume"

        params do
          requires :resume
        end

        post "", root: "resumes" do
          filtered_params = permitted_params[:resume].select{ |k, v| v != 'null' }
          primary_email = filtered_params['primary_email']
          first_name = filtered_params['first_name']
          last_name  = filtered_params['last_name']
          zip        = filtered_params['zip']
          address1   = filtered_params['address1']
          address2   = filtered_params['address2']
          address    = address1.to_s + ' ' + address2.to_s
          p address
          city       = filtered_params['city']
          state      = filtered_params['state']
          content    = filtered_params['content']
          errors = {}
          if primary_email.nil?
            errors[:primary_email] = ['Primary Email is blank, you must supply a Primary Email.']
          end
          if first_name.nil?
            errors[:first_name] = ['First Name is blank, you must supply a First Name.']
          end
          if last_name.nil?
            errors[:last_name] = ['Last Name is blank, you must supply a Last Name.']
          end
          if zip.nil? && (address.nil? || city.nil? || state.nil?)
            errors[:zip] = ['Zip is blank, you must supply either a Zip or Address/City/State.']
          end
          unless STATES.map{ |state| state[0] }.include? state
            errors[:state] = ['State must be a valid two letter abbreviation']
          end
          unless errors.length == 0
            error!(
              {
                errors: errors
              },
              422
            )
          end
          resume = Resume.find_by(primary_email: primary_email)
          if resume
            error!({errors: {primary_email: ['This person already exists']}}, 422)
          end
          resume = Resume.where(
            first_name: first_name.try(:capitalize),
            last_name:  last_name.try(:capitalize),
            zip:        zip
          ) if first_name && last_name && zip
          if resume.first
            error!(
              {
                errors: {
                  last_name: ['A person with the same name already exists in this zip'],
                  first_name: ['A person with the same name already exists in this zip']
                }
              },
              422
            )
          end
          resume_params = filtered_params.to_hash.except('other_resumes', 'content')
          loc = API::V1::Resumes.geocode(address, city, state, zip)
          resume_params['location'] = loc if loc
          resume = Resume.new(resume_params)
          API::V1::Resumes.build_other_resume(resume, content)

          unless resume.save
            return {errors: resume.errors.full_messages}
          end
        end

        desc "put a complete resume"

        params do
          requires :id, type: String, desc: "ID of the resume"
          optional :resume
        end

        put ":id", root: "resumes" do
          resume = Resume.find(permitted_params[:id])
          if resume
            resume_params = permitted_params[:resume].to_hash.except('other_resumes')
            address = permitted_params[:resume][:address1]
            city = permitted_params[:resume][:city]
            state = permitted_params[:resume][:state]
            zip = permitted_params[:resume][:zip]
            loc = API::V1::Resumes.geocode(address, city, state, zip)
            resume_params['location'] = loc if loc
            #other_resume_params = resume_params['other_resumes'].map { |other_resume| other_resume.except('resume_id') }
            #resume_params['other_resumes'] = other_resume_params
            resume.update(resume_params)
          else
            "error - resume cannot be found"
          end
        end

        desc "return a resume"

        params do
          requires :id, type: String, desc: "ID of the resume"
        end

        get ":id" do
          id = permitted_params[:id]
          resume = [Resume.find_by(:id => params[:id])]
          present :resume, resume, with: API::V1::ResumeEntity
        end

        desc "return some resumes"

        params do
          optional :search_term, type: String, desc: "full text search terms seperated by | character for logical AND search"
          optional :location, type: String, desc: "lat long for location search"
          optional :radius, type: String, desc: "search radius in miles"
          optional :primary_email, type: String, desc: "primary email used by candidate"
          optional :last_name, type: String, desc: "last name of candidate"
          optional :first_name, type: String, desc: "first name of candidate"
          optional :state, type: String, desc: "last name of candidate"
        end

        get "", root: "resume" do
          conditions = {}
          if permitted_params[:search_term] && permitted_params[:search_term] != 'null'
            search_term = permitted_params[:search_term]
            search_regex = API::V1::Resumes.parse_search(search_term) if permitted_params[:search_term]
            conditions['other_resumes.resume_text'] = search_regex if search_term
          end
          permitted_params.each do |key, value|
            if
              key.to_s != 'search_term' &&
              key.to_s != 'location' &&
              key.to_s != 'radius' &&
              value != 'undefined' &&
              value != ""
              value != 'null'
              !value.empty?
                conditions[key] = value
            end
          end

          location = nil
          coordinates = [nil,nil]
          if !permitted_params[:location].nil? && permitted_params[:location] != "undefined" && permitted_params[:location] != "null" && !permitted_params[:location].blank?
            location = permitted_params[:location]
            if permitted_params[:radius] &&
              !permitted_params[:radius].nil? &&
              permitted_params[:radius] != "undefined" &&
              permitted_params[:radius] != "null" &&
              permitted_params[:radius] =~ /\A\d+(\.\d+)?\Z/
              radius = permitted_params[:radius].to_i / 3963.2
            else
              radius = 200 / 3693.2
            end
            loc = MultiGeocoder.geocode(location)
            if loc.success
              coordinates = [loc.lng, loc.lat]
            end
          elsif conditions.has_key? 'state'
            loc = MultiGeocoder.geocode(conditions['state'])
            if loc.success
              coordinates = [loc.lng, loc.lat]
            end
          end
          if !location.nil?
            resumes = Resume.where(conditions).geo_near(coordinates).max_distance(radius).spherical.each do |r|
                r['id'] = r._id
                r.distance = r['geo_near_distance']
              end
          elsif conditions && conditions != {}
            resumes = Resume.without(:resume_text).where(conditions)
          end
          search_location = [{id: "1", coordinates: coordinates}]
          present :resumes, resumes, with: API::V1::ResumeEntity
          present :search_location, search_location
        end
      end

      def self.geocode(address1=nil, city=nil, state=nil, zip=nil)
        loc = MultiGeocoder.geocode("#{address1}, #{city}, #{state} #{zip}")
        unless loc.success
          loc = MultiGeocoder.geocode(zip)
        end
        if loc.success
          [loc.lng, loc.lat]
        else
          nil
        end
      end

      def self.parse_search(search_term)
        terms_components = search_term.split("\n").map{ |term| "(?=.*#{term})" }.join("")
        /#{terms_components}.*/im
      end

      def self.grid_file_id(file)
        grid_fs = Mongoid::GridFs
        grid_fs.put(file).id
      end

      def self.build_other_resume(resume, content)
        p content
        md5sum = Digest::MD5.hexdigest content.tempfile.to_s
        resume_text = Yomu.new(content.tempfile).text
        fake_file = content.tempfile
        extension = $1 if content.filename.match(/\.(.*)/)
        resume.other_resumes.new(
          resume_text: resume_text,
          doctype: extension,
          filename: content.filename,
          md5sum: md5sum,
          last_update: Time.now,
          resume_grid_fs_id: API::V1::Resumes.grid_file_id(fake_file)
        )
      end
    end

  end
end
