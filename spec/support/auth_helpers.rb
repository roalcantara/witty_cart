module AuthHelpers
  def authenticate(factory = nil, user: nil)
    before :all do
      @current_user = user || create(*factory)
    end

    before do
      sign_in @current_user if @request.present?
      # User.current = @current_user
    end

    after do
      sign_out @current_user if @request.present?
      # User.current = nil
    end
  end

  # Mocking warden methods for routing tests
  # issue https://github.com/plataformatec/devise/issues/1670
  def mock_warden_for_route_tests_with(factory)
    before(:all) { @user = create(factory, :confirmed) }
    before do
      warden = double
      allow_any_instance_of(ActionDispatch::Request).to receive(:env)
        .and_wrap_original do |orig, *args|
        env = orig.call(*args)
        env['warden'] = warden
        env
      end
      allow(warden).to receive(:authenticate!).and_return true
      allow(warden).to receive(:user).and_return @user
    end
  end
end

RSpec.configure do |config|
  %i(controller view helper service routing model).each do |type|
    config.extend AuthHelpers, type: type
  end
end
