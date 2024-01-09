class User < ApplicationRecord
  validates :username, :email, :session_token, presence: true, uniqueness: true
  validates :username, length: { in: 3..40 }, format: { without: URI::MailTo::EMAIL_REGEXP, message:  "can't be an email" }
  validates :email, length: {in: 3..100},  format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, allow_nil: true, length: { in: 6..40 } 

  has_secure_password

  before_validation :ensure_session_token
  
  
  
  def self.find_by_credentials(credential, password) 
    
    if URI::MailTo::EMAIL_REGEXP.match(credential)
      user = User.find_by(email: credential)
    else 
      user = User.find_by(username: credential)
    end
    #user && user.authenticate(password)


    if user&.authenticate(password)
      return user 
    else  
      return nil 
    end
  end


  def reset_session_token! 
    self.session_token = generate_unique_session_token
    self.save!
    self.session_token
  end


  private 


  def generate_unique_session_token 
    while true 
      token = SecureRandom.urlsafe_base64
      return token unless User.exists?(session_token: token)
    end
  end

  def ensure_session_token 
    self.session_token ||= generate_unique_session_token
  end

  def require_logged_in
    unless current_user
      render json: { message: 'Unauthorized' }, status: :unauthorized 
    end
  end




end
