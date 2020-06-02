class UsersController < ApplicationController
  before_filter :login_required, only: [:show, :destroy, :sign_out]
  before_filter :login_rejected, only: [:sign_up, :sign_in]

  # Get: Show User
  def show
  end

  # POST: Create User / Sign Up
  def sign_up
    if(params[:password] != params[:password_confirmation])
      return render json: { errors: ["Password and password confirmation must be the same"] }, status: 400
    end

    user = User.new(user_params)
    if user.save
      token = user.generate_auth_token
      cookies.encrypted[:Authorization] = { value: token, httponly: true }
      render json: current_user.as_json, status: 200
    else
      render json: { errors: user.errors.full_messages }, status: 400
    end
  end

  # DELETE: Delete Account
  def destroy
    current_user.destroy()
    head 204
  end


  # ---------------------------------------------------------------------------- #
  # ----------------------------- SESSION CONTROLS ----------------------------- #
  # ---------------------------------------------------------------------------- #

  # POST: Sign In
  def sign_in
    # Find user
    user = User.find_by(email: params[:email].downcase)

    # Check if user exists and password is correct
    unless user&.password_is?(params[:password])
      return render json: { errors: ["email/password is incorrect"] }, status: 400
    end

    token = user.generate_auth_token
    cookies.encrypted[:Authorization] = { value: token, httponly: true }

    render json: current_user.as_json, status: 200
  end

  # DELETE: Sign Out
  def sign_out
    cookies.delete(:Authorization)
    head 204
  end

  # GET: Check if you are signed in
  def signed_in
    if current_user
      render json: current_user.as_json, status: 200
    else
      head 401
    end
  end

  private

  def user_params
    params.permit(:username, :email, :password)
  end
end
