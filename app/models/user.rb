class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  # attr_accessible :title, :body

  has_many :authentications

  def password_required?
    super && (authentications.empty? || password.present?)
  end

  def self.new_with_session(params, session)
    super.tap do |user|
      if auth = session['devise.omniauth.auth']
        user.assign_attributes_from_omniauth(auth)
      end
    end
  end

  def assign_attributes_from_omniauth(auth)
    self.email = auth[:info][:email] if email.blank?
    build_authentication(auth)
  end

  def add_authentication!(auth)
    build_authentication(auth).save!
  end

private

  def build_authentication(auth)
    authentications.build Authentication.attributes_from_omniauth(auth)
  end
end
