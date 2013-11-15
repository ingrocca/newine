# Someone who uses this excellent piece of software.
class Admin < ActiveRecord::Base
  #attr_accessible :email, :hashed_password, :salt, :username
  validates :username, :length => {:within => 3..40}
  validates :password, :length => {:within => 5..40}
  validates :username, :presence => true, :uniqueness => true
  validates :email, :presence => true, :uniqueness => true
  validates :password, :presence => true
  validates :password_confirmation, :presence => true
  validates :salt, :presence => true
  validates :is_super_admin, :inclusion => {:in => [true, false]}
  validates :password, :confirmation => true
  validates :email, :format => {:with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, :message => "Invalid email" }

  attr_accessor :password, :password_confirmation

  # Authenticate a user.
  def self.authenticate(username, pass)
    u=find(:first, :conditions=>["username = ?", username])
    return nil if u.nil?
    #puts u.attributes
    return u if Admin.encrypt(pass, u.salt)==u.hashed_password
    nil
  end  

  # Saves password (actually a hashed version of it)
  def password=(pass)
    @password=pass
    self.salt = Admin.random_string(10) if !self.salt?
    self.hashed_password = Admin.encrypt(@password, self.salt)
  end

  # Mails a new password to someone who forgot it (not used, never tested, probably doesn't work)
  def send_new_password
    new_pass = Admin.random_string(10)
    self.password = self.password_confirmation = new_pass
    self.save
    Notifications.deliver_forgot_password(self.email, self.login, new_pass)
  end

  protected

  # Encrypts a password using SHA1
  def self.encrypt(pass, salt)
    Digest::SHA1.hexdigest(pass+salt)
  end

  # Generates a random string of a certain length. 
  def self.random_string(len)
    #generat a random password consisting of strings and digits
    chars = ("a".."z").to_a + ("A".."Z").to_a + ("0".."9").to_a
    newpass = ""
    1.upto(len) { |i| newpass << chars[rand(chars.size-1)] }
    return newpass
  end
  def name
    username
  end
end
