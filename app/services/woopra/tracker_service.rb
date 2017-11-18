module Woopra
  class TrackerService
    def self.track(event_name, properties = {}, user_id = User.current&.id)
      TrackerJob.perform_later Tracker.current_configuration,
                               user_id,
                               event_name.to_s,
                               properties
    end

    def self.track_sign_up(user)
      track :sign_up, {
        id: user.id,
        name: user.name,
        email: user.email,
        admin: user.admin?
      }, user.id
    end

    def self.track_sign_in(user)
      track :sign_in, {
        id: user.id,
        name: user.name,
        email: user.email,
        admin: user.admin?
      }, user.id
    end

    private_class_method :track
  end
end
