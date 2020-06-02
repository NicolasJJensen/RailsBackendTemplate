class User < ApplicationRecord
  #------------------------------------------------------------------------------------------#
  #--------------------------------------- Relations ----------------------------------------#
  #------------------------------------------------------------------------------------------#



  #------------------------------------------------------------------------------------------#
  #-------------------------------------- Validations ---------------------------------------#
  #------------------------------------------------------------------------------------------#

  # Constants
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  # Validation
  validates :username, presence: true, length: { maximum: 50 }
  validates :email, presence: true, length: { maximum: 255 }, format: { with: VALID_EMAIL_REGEX }, uniqueness: true
  validates :password, presence: true, length: { minimum: 6 }


  # Call hooks
  before_save :format_email
  before_save :encrypt_password


  #------------------------------------------------------------------------------------------#
  #----------------------------------- Instance Functions -----------------------------------#
  #------------------------------------------------------------------------------------------#

  # Returns a token tied to the user_id with an expiry
  def generate_auth_token(remember_me = false)
    exp = remember_me ? 7.days.from_now : 24.hours.from_now
    payload = {
      id: self.id,
      exp: exp.to_i
    }
    JWT.encode(payload, Rails.application.secrets.secret_key_base)
  end

  # Checks if the input password is the same as the user password
  def password_is?(test_password)
    BCrypt::Password.new(self.password).is_password?(test_password)
  end


  #------------------------------------------------------------------------------------------#
  #------------------------------------ Class Functions -------------------------------------#
  #------------------------------------------------------------------------------------------#




  #------------------------------------------------------------------------------------------#
  #----------------------------------------- Hooks ------------------------------------------#
  #------------------------------------------------------------------------------------------#


  private

  # Formats the users email to be lowercase
  def format_email
    self.email = email.downcase
  end

  # Returns the hash of the given string.
  def encrypt_password
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    self.password = BCrypt::Password.create(password, cost: cost)
  end
end
