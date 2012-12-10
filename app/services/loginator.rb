class Loginator

  def initialize(attrs = {})
    @auth = attrs[:auth]
    @current_user = attrs[:current_user]
    @session = attrs[:session]
    @user_signed_in = !!@current_user
  end

  def omniauth_auth
    @auth.except(:extra)
  end

  def authenticates?
    authentication.present?
  end

  def user
    authenticates? && authentication.user
  end

private

  attr_reader :session, :user_signed_in

  def authentication
    @authentication ||= Authentication.find_by_omniauth(omniauth_auth)
  end

  def signed_in?
    @signed_in
  end
end