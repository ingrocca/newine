# Someone who uses this excellent piece of software.
class Admin < ActiveRecord::Base
  include Shield::Model

  validates :email, presence: true, uniqueness: true, on: :create
  validates :email, :format => {:with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, :message => "Invalid email" }

  attr_reader :password

  class << self
    def [](id)
      find id
    end
    
    def fetch(identifier)
      where(email: identifier).first
    end

    def password=(password)
      self.crypted_password = Shield::Password.encrypt(password.to_s)
    end
  end

  # Mails a new password to someone who forgot it (not used, never tested, probably doesn't work)
  def send_new_password
    new_pass = Admin.random_string(10)
    self.password = self.password_confirmation = new_pass
    self.save
    Notifications.deliver_forgot_password(self.email, self.login, new_pass)
  end

end
