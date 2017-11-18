module Signinable
  extend ActiveSupport::Concern

  module ClassMethods
    def current=(user)
      Thread.current[:user] = user
    end

    def current
      Thread.current[:user]
    end
  end
end
