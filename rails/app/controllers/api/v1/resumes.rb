module API
  module V1

    class Resumes < Grape::API
      require 'mongoid/grid_fs'
      require 'geokit'

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
        end

        get "files/:resume_grid_fs_id", root: "resume" do
          content_type 'application/octet-stream'
          header['content-Disposition'] = "attachment; filename='#{permitted_params[:filename]}'"
          env['api.format'] = :binary

          grid_fs = Mongoid::GridFs
          grid_fs.get(permitted_params[:resume_grid_fs_id]).data
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
          if !permitted_params[:location].nil? && permitted_params[:location] != "undefined" && permitted_params[:location] != "null"
            p 'in location'
            p "radius #{permitted_params[:radius] =~ /\A\d+?(\.\d+)\Z/}"
            if permitted_params[:radius] &&
              !permitted_params[:radius].nil? &&
              permitted_params[:radius] != "undefined" &&
              permitted_params[:radius] != "null" &&
              permitted_params[:radius] =~ /\A\d+(\.\d+)?\Z/
              p 'got here'
              radius = permitted_params[:radius].to_i / 3963.2
            else
              radius = 200 / 3693.2
            end
            loc = MultiGeocoder.geocode(permitted_params[:location])
            if loc.success
              location = [loc.lng, loc.lat]
            end
          end
          if !location.nil?
            resumes = Resume.where(conditions).geo_near(location).max_distance(radius).spherical.each do |r|
                r['id'] = r._id
                r.distance = r['geo_near_distance']
              end
            search_location = [{id: "1", coordinates: location}]
            present :resumes, resumes, with: API::V1::ResumeEntity
            present :search_location, search_location
          elsif conditions && conditions != {}
            resumes = Resume.without(:resume_text).where(conditions)
            present resumes, with: API::V1::ResumeEntity
          end
        end
      end

      def self.parse_search(search_term)
        terms_components = search_term.split("\n").map{ |term| "(?=.*#{term})" }.join("")
        /#{terms_components}.*/im
      end
    end

  end
end
