class User < ActiveRecord::Base
  has_many :desires, :dependent => :destroy
  has_many :items, :through => :desires
  has_many :feedbacks, :through => :desires

  validates_length_of :login, :within => 3..32
  validates_length_of :password, :within => 5..64
  validates_presence_of :login, :email, :password, :password_confirmation
  validates_uniqueness_of :login, :email, :case_sensitive => false
  validates_format_of :email, :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i, :message => "Invalid email"  
  validates_confirmation_of :password
  
  attr_accessor :password, :password_confirmation
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
