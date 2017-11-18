# frozen_string_literal: true

module Woopra
  class TrackerJob < ApplicationJob
    queue_as :default

    def perform(configuration, user_id, event_name, properties)
      user = User.find user_id
      tracker = Tracker.new configuration
      tracker.config domain: WittyCart.woopra_domain
      tracker
        .identify(
          id: user.id,
          name: user.name,
          email: user.email
        ).track(event_name, properties, true)

      logger.info tracker.response
    end
  end
end
