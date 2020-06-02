class ApplicationController < ActionController::API
  include UsersHelper
  include ActionController::MimeResponds
  include ActionController::Cookies

  def login_required
    if current_user
      render json: { errors: ["You must be logged in to access this page"] }, status: 400
      return false
    end
    return true
  end

  def login_rejected
    if !current_user
      render json: { errors: ["You are already logged in, please log out before attempting to access this page"] }, status: 400
      return true
    end
    return false
  end
end
