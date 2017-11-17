require 'application_responder'

class ApplicationController < ActionController::Base
  include Breadcrumbable

  before_action :add_breadcrumbs, if: :devise_controller?

  self.responder = ApplicationResponder
  respond_to :html

  protect_from_forgery with: :exception

  private

  def add_breadcrumbs
    add_breadcrumb User.to_s
  end
end
