# Someone who uses this excellent piece of software.
class Admin < ActiveRecord::Base
  include Shield::Model
  
  validates :username, :length => {:within => 3..40}
  validates :password, :length => {:within => 5..40}, on: :create
  validates :username, presence: true, uniqueness: true, on: :create
  validates :email, presence: true, uniqueness: true, on: :create
  validates :password, presence: true, on: :create
  validates :password_confirmation, presence: true, on: :create
  validates :password, :confirmation => true
  validates :email, :format => {:with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, :message => "Invalid email" }

  attr_accessor :password, :password_confirmation

  class << self
    def [](id)
      find id
    end
    
    def fetch(identifier)
      where(email: identifier).first || where(username: identifier).first
    end
  end 

  # Saves password (actually a hashed version of it)
  def password=(pass)
    self.crypted_password = Shield::Password.encrypt(pass)
  end

  # Mails a new password to someone who forgot it (not used, never tested, probably doesn't work)
  def send_new_password
    new_pass = Admin.random_string(10)
    self.password = self.password_confirmation = new_pass
    self.save
    Notifications.deliver_forgot_password(self.email, self.login, new_pass)
  end

end
