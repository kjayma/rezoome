module API
  class BaseEntity < Grape::Entity
    expose :_id, as: :id, documentation: { type: 'String', desc: 'BSON::ObjectId String' }, :format_with => :to_string
    format_with(:to_string) { |id| id.to_s }
  end
end
