module Admin
  class UsersController < ApplicationController
    before_action :set_user, only: %i(show)

    def index
      @users = User.all.order :id
    end

    def show; end

    def set_user
      @user = User.find params[:id]
    end
  end
end
