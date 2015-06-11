module API
  module V1
    module Defaults
      extend ActiveSupport::Concern

      included do
        prefix "api"
        version "v1", using: :path
        default_format :json
        format :json
        formatter :json, Grape::Formatter::ActiveModelSerializers

        helpers do
          def permitted_params
            @permitted_params ||= declared(params, include_missing: false)
          end

          def logger
            Rails.logger
          end
        end

        rescue_from Mongoid::Errors::DocumentNotFound do |e|
          error_response(message: e.message, status: 404)
        end

        rescue_from Mongoid::Errors::InvalidCollection do |e|
          error_response(message: e.message, status: 422)
        end
      end
    end
  end
end
