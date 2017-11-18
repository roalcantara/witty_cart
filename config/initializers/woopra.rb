require 'woopra'

ActiveSupport.on_load(:action_controller) do
  include Woopra::Controller
end
