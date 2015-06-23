require_relative '../base_entity'

module API
  module V1
    class OtherResumeEntity < BaseEntity
      # _id will be exposed through class inheritance
      expose :last_update
      expose :resume_text
      expose :created_at
      expose :updated_at
    end
  end
end
