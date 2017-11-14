require 'rails_helper'

RSpec.describe Admin::DashboardController do
  authenticate :admin

  describe 'GET #index' do
    subject! { get :index }

    it { expect(response).to have_http_status :success }
  end
end
