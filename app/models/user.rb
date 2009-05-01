class User < ActiveRecord::Base
  validates_length_of :login, :within => 3..32
  validates_length_of :password, :within => 5..64
  validates_presence_of :login, :email, :password
  validates_uniqueness_of :login, :email, :case_sensitive => false
  validates_format_of :email, :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i, :message => "Invalid email"  
  
  attr_accessor :password
  attr_protected :id
  
  def password=(pass)
    @password = pass
    self.hashed_password = User.encrypt(pass)
  end
  
  def self.authenticate(login, pass)
    u = find :first, :conditions => ['login = ?', login]
    return u if u and User.encrypt(pass) == u.hashed_password
    nil
  end
  
  protected
  
  def self.encrypt(pass)
    Digest::MD5.hexdigest(pass)
  end
end
