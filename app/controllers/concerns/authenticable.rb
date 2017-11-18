module Authenticable
  extend ActiveSupport::Concern

  included do
    DEVISE_SANITIZER_ACTIONS = %i(sign_up account_update).freeze
    DEVISE_EXTRA_RESOURCE_PARAMS = %i(name).freeze

    protect_from_forgery with: :exception
    skip_before_action :verify_authenticity_token, if: -> { controller_name == 'sessions' && action_name == 'create' }
    before_action :configure_permitted_parameters, if: :devise_controller?
    before_action :set_user_current

    private

    def configure_permitted_parameters
      DEVISE_SANITIZER_ACTIONS.each do |step|
        devise_parameter_sanitizer.permit step, keys: DEVISE_EXTRA_RESOURCE_PARAMS
      end
    end

    def set_user_current
      User.current = current_user
    end
  end
end
