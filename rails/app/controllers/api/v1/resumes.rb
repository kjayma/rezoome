module API
  module V1

    class Resumes < Grape::API

      include API::V1::Defaults
      require 'mongoid/grid_fs'

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
          optional :zip, type: String, desc: "zip code for location search"
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
            if !value.empty? && value != 'undefined' && key.to_s != 'search_term'
              conditions[key] = value
            end
          end

          resumes = Resume.
            only(
              :id,
              :md5sum,
              :primary_email,
              :filename,
              :last_update,
              :first_name,
              :last_name,
              :address1,
              :address2,
              :city,
              :state,
              :zip,
              :home_phone,
              :mobile_phone,
              :doctype,
              :notes,
              :location,
              :resume_grid_fs_id,
              :created_at,
              :updated_at
            ).
            where( conditions )
          present resumes, with: API::V1::ResumeEntity
        end
      end

      def self.parse_search(search_term)
        terms_components = search_term.split('|').map{ |term| "(?=.*#{term})" }.join("")
        /#{terms_components}.*/im
      end
    end

  end
end
