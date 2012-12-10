module Users
  class OmniauthCallbacksController < Devise::OmniauthCallbacksController

    attr_reader :auth
    helper_method :auth

    # Some of this logic coming from
    # https://github.com/intridea/omniauth/wiki/Managing-Multiple-Providers
    # https://github.com/plataformatec/devise/wiki/OmniAuth:-Overview
    def callback
      auth = env["omniauth.auth"]

      loginator = Loginator.new auth: auth, current_user: current_user, session: session

      if user_signed_in?
        if loginator.authenticates? # an auth with these credentials is found
          if loginator.user == current_user # Already exists for this user, just sign back in
            redirect_to after_sign_in_path_for(loginator.user), notice: "You've already got this auth!"
          else
            # This auth exists for a different user, do they have two users?
            # at this point, what do we do?
          end
        else # auth does NOT exist with these credentials
          current_user.add_authentication!(auth)
          redirect_to after_sign_in_path_for(loginator.user), notice: "New Auth Added!"
        end
      else
        if loginator.authenticates?
          sign_in_user loginator.user
          redirect_to after_sign_in_path_for(loginator.user), notice: "Signed In!"
        else
          session['devise.omniauth.auth'] = loginator.omniauth_auth
          redirect_to new_user_registration_path, notice: "Finish signing up"
        end
      end

    end

    alias_method :facebook, :callback
    alias_method :twitter,  :callback
    alias_method :linkedin, :callback

    def retry
    end

  end
end