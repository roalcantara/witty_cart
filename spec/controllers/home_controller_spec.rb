require 'rails_helper'

RSpec.describe HomeController do
  authenticate :user

  describe 'GET #index' do
    subject! { get :index }

    it { is_expected.to have_http_status :success }
  end
end
