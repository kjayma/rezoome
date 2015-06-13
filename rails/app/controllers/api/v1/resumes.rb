module API
  module V1

    class Resumes < Grape::API

      include API::V1::Defaults

      resource :resumes do
        desc "Return a resume"

        params do
          requires :id, type: String, desc: "ID of the resume"
        end

        get ":id", root: "resume" do
          Resume.find_by(id: permitted_params[:id])
        end

        desc "return some resumes"

        params do
          optional :search_term, type: Array, desc: "full text search terms seperated by | character for logical AND search"
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
          conditions[:primary_email] = permitted_params[:primary_email] if permitted_params[:primary_email]
          conditions[:last_name] = permitted_params[:last_name] if permitted_params[:last_name]
          conditions[:first_name] = permitted_params[:first_name] if permitted_params[:first_name]
          conditions[:state] = permitted_params[:state] if permitted_params[:state]
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
              :resume_grid_fs_id,
              :created_at,
              :updated_at
            ).
            where( conditions ).limit(100)
          present resumes, with: API::V1::ResumeEntity
        end
      end

      def self.parse_search(search_term)
        terms_components = search_term.map{ |term| "(?=.*#{term})" }.join("")
        /#{terms_components}.*/im
      end
    end

  end
end
