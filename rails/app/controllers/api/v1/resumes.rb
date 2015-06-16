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
        end

        get "files/:resume_grid_fs_id", root: "resume" do
          content_type 'application/octet-stream'
          header['content-Disposition'] = "attachment;"
          env['api.format'] = :binary

          grid_fs = Mongoid::GridFs
          grid_fs.get(permitted_params[:resume_grid_fs_id]).data
        end

        desc "return some resumes"

        params do
          optional :search_term, type: String, desc: "full text search terms seperated by | character for logical AND search"
          optional :location, type: String, desc: "lat long for location search"
          optional :radius, type: Integer, desc: "search radius in miles"
          optional :primary_email, type: String, desc: "primary email used by candidate"
          optional :last_name, type: String, desc: "last name of candidate"
          optional :first_name, type: String, desc: "first name of candidate"
          optional :state, type: String, desc: "last name of candidate"
        end

        get "", root: "resume" do
          search_term = permitted_params[:search_term]
          search_regex = API::V1::Resumes.parse_search(search_term) if permitted_params[:search_term]
          conditions = {}
          conditions[:resume_text] = search_regex if search_term
          permitted_params.each do |key, value|
            if
              key.to_s != 'search_term' &&
              key.to_s != 'location' &&
              key.to_s != 'radius' &&
              value != 'undefined' &&
              !value.empty?
                conditions[key] = value
            end
          end

          location = nil
          if !permitted_params[:location].nil?
            radius = (permitted_params[:radius] && !permitted_params[:radius].nil? ?  permitted_params[:radius].to_i : 200) / 3963.2
            loc = MultiGeocoder.geocode(permitted_params[:location])
            if loc.success
              location = [loc.lng, loc.lat]
            end
          end
          if !location.nil?
            resumes = Resume.without(:resume_text).where(conditions).geo_near(location).max_distance(radius).spherical.each do |r|
                r['id'] = r._id
                r.distance = r['geo_near_distance']
              end
          elsif conditions && conditions != {}
            resumes = Resume.without(:resume_text).where(conditions)
            present resumes, with: API::V1::ResumeEntity
          end
        end
      end

      def self.parse_search(search_term)
        terms_components = search_term.split('|').map{ |term| "(?=.*#{term})" }.join("")
        /#{terms_components}.*/im
      end
    end

  end
end
