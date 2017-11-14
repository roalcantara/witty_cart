require 'rails_helper'

RSpec.describe Admin::UsersController do
  authenticate :admin

  describe 'GET #index' do
    subject! { get :index, params: {} }

    it { expect(response).to have_http_status :success }
    it { expect(response).to render_template :index }

    it 'assigns all users as @users' do
      expect(assigns(:users)).to include(*User.all)
    end
  end

  describe 'GET #show' do
    let!(:user) { create :user }

    subject! { get :show, params: { id: user.to_param } }

    it { expect(response).to have_http_status :success }
    it { expect(response).to render_template :show }

    it 'assigns the requested user as @user' do
      expect(assigns(:user)).to eq user
    end
  end
end
