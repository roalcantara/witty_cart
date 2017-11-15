module Admin
  class UsersController < ApplicationController
    before_action :set_user, only: %i(show)
    before_action :add_breadcrumbs

    def index
      @users = User.all.order :id
    end

    def show; end

    def set_user
      @user = User.find params[:id]
    end

    private

    def add_breadcrumbs
      add_breadcrumb User
      add_breadcrumb @user.to_s if @user
    end
  end
end
