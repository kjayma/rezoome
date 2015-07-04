require_relative '../base_entity'

module API
  module V1
    class ResumeEntity < BaseEntity
      # _id will be exposed through class inheritance
      expose :md5sum
      expose :primary_email
      expose :filename
      expose :last_update
      expose :first_name
      expose :last_name
      expose :address1
      expose :address2
      expose :city
      expose :state
      expose :zip
      expose :home_phone
      expose :mobile_phone
      expose :doctype
      expose :notes
      expose :other_resumes, using: API::V1::OtherResumeEntity
      expose :resume_grid_fs_id
      expose :created_at
      expose :updated_at
      expose :distance
    end
  end
end
