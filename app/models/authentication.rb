class Authentication < ActiveRecord::Base
  belongs_to :user
  attr_accessible :provider, :token, :uid

  def self.find_by_omniauth(auth)
    find_by_provider_and_uid(auth[:provider], auth[:uid])
  end

  def self.create_from_omniauth!(auth)
    build_from_omniauth(auth).save!
  end

  def self.attributes_from_omniauth(auth)
    {
      provider: auth[:provider],
      uid: auth[:uid],
      token: auth[:credentials][:token]
    }
  end
end
