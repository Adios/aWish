require 'test_helper'

class UserTest < ActiveSupport::TestCase
  self.use_instantiated_fixtures  = true
  
  test 'authentication' do
    #check that we can login we a valid user 
    assert_equal  @adios, User.authenticate('adios', 'testtest')    
    #wrong username
    assert_nil    User.authenticate('adioa', 'testtest')
    #wrong password
    assert_nil    User.authenticate('adios', 'tesss')
    #wrong login and pass
    assert_nil    User.authenticate('wancc', 'testtestt')
  end
  
  test 'disallowed password' do
    #check that we can't create a user with any of the disallowed paswords
    u = User.new    
    u.login = 'alison'
    u.email = 'alison@alison.org'
    #too short
    u.password = u.password_confirmation = '123' 
    assert !u.save     
    assert u.errors.invalid?('password')
    #too long
    u.password = u.password_confirmation = '1234' * 16 + '1'
    assert !u.save     
    assert u.errors.invalid?('password')
    #empty
    u.password = u.password_confirmation = ''
    assert !u.save    
    assert u.errors.invalid?('password')
    #ok
    u.password = u.password_confirmation = 'alison_secure_password'
    assert u.save     
    assert u.errors.empty? 
  end
  
  test 'bad logins and bad mails' do
    #check we cant create a user with an invalid username
    u = User.new  
    u.password = u.password_confirmation = 'alisonisthebest'
    u.email = 'alison@alison.org'
    #too short
    u.login = 'x'
    assert !u.save     
    assert u.errors.invalid?('login')
    #too long
    u.login = '1234' * 8 + '1'
    assert !u.save     
    assert u.errors.invalid?('login')
    #empty
    u.login = ''
    assert !u.save
    assert u.errors.invalid?('login')
    #ok
    u.login = 'mac'
    assert u.save  
    assert u.errors.empty?
    #no email
    u.email = nil   
    assert !u.save     
    assert u.errors.invalid?('email')
    #invalid email
    u.email = 'notavalidemail'   
    assert !u.save     
    assert u.errors.invalid?('email')
    #ok
    u.email='validbob@mcbob.com'
    assert u.save  
    assert u.errors.empty?
  end
  
  test 'collision' do 
    #check can't create new user with existing username
    u = User.new :login => 'adios', :password => 'test222', :password_confirmation => 'test222', :email => 'adios@la.com'
    assert !u.save
    assert u.errors.invalid?('login')
    # case-insensitive ?
    u.login = 'Adios'
    assert !u.save
    assert u.errors.invalid?('login')
    # mail
    u.login = 'soida'
    u.email = 'adiosf6f@gmail.com'
    assert !u.save
    assert u.errors.invalid?('email')
    # case-insensitive ?
    u.email = 'AdiosF6F@Gmail.com'
    assert !u.save
    assert u.errors.invalid?('email')
  end

  test 'creation' do
    #check create works and we can authenticate after creation
    u = User.new :login => 'alison', :password => 'alisonisthebest', :password_confirmation => 'alisonisthebest', :email => 'alison@alison.org'
    assert u.save
    assert_equal u, User.authenticate(u.login, u.password)
  end
  
  test 'md5' do
    u = User.new
    u.login = 'alison'
    u.email = 'alison@alison.org'
    u.password = u.password_confirmation = 'alisonisthebest'
    assert u.save
    assert_equal '0c8cba7242f30ddd34aa804356f47245', u.hashed_password
    assert_equal '0c8cba7242f30ddd34aa804356f47245', User.encrypt('alisonisthebest')
  end

  test 'protected attributes' do
    #check attributes are protected
    u = User.new :id => 999999, :login => 'alison', :password_confirmation => 'alisonisthebest', :password => 'alisonisthebest', :email => 'alison@alison.org'
    assert_nil u.id
    assert u.save
    assert_not_equal 999999, u.id

    u.update_attributes :id => 999999, :login => 'aaa'
    assert u.save
    assert_not_equal 999999, u.id
    assert_equal 'aaa', u.login
  end
  
  test "dependent" do
    # test dependent
    assert_difference "Desire.count", -2 do
      User.destroy(@adios)
    end
  end

end

