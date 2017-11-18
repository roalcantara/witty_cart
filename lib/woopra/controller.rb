module Woopra
  module Controller
    def self.included(controller)
      controller.before_action(
        :set_woopra_configuration
      )
    end

    private

    def set_woopra_configuration
      Tracker.add_configuration_to_current_thread request
    end
  end
end
