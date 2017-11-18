module Authenticable
  extend ActiveSupport::Concern

  included do
    protect_from_forgery with: :exception
    skip_before_action :verify_authenticity_token, if: -> { controller_name == 'sessions' && action_name == 'create' }
    before_action :set_user_current

    private

    def set_user_current
      User.current = current_user
    end
  end
end
