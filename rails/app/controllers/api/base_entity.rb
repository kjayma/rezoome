module API
  class BaseEntity < Grape::Entity
    expose :_id, as: :id, documentation: { type: 'String', desc: 'BSON::ObjectId String' }
  end
end
