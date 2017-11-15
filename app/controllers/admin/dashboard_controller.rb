module Admin
  class DashboardController < ApplicationController
    before_action :add_breadcrumbs

    def index; end

    private

    def add_breadcrumbs
      add_breadcrumb 'Dashboard'
    end
  end
end
