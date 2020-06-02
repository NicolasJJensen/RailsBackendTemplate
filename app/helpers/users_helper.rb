module UsersHelper
  # Finds the current users based on cookie token
  def current_user
    token = cookies.encrypted[:Authorization]
    user_details = HashWithIndifferentAccess.new(JWT.decode(token, Rails.application.secrets.secret_key_base)[0])
    User.find(user_details[:id])
  rescue
    cookies.delete(:Authorization)
    nil
  end
end
