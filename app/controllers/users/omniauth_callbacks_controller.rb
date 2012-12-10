module Users
  class OmniauthCallbacksController < Devise::OmniauthCallbacksController

    attr_reader :auth
    helper_method :auth

    def callback
      @auth = env["omniauth.auth"]
      binding.pry
    end
    alias_method :facebook, :callback
    alias_method :twitter,  :callback
    alias_method :linkedin, :callback

    def retry
    end

  end
end