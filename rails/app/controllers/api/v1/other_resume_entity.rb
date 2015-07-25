require_relative '../base_entity'

module API
  module V1
    class OtherResumeEntity < BaseEntity
      # _id will be exposed through class inheritance
      expose :_id, :as => :id
      expose :last_update
      expose :doctype
      expose :filename
      expose :resume_text
      expose :resume_grid_fs_id
      expose :created_at
      expose :updated_at
    end
  end
end
