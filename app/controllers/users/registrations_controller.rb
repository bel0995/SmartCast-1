class Users::RegistrationsController < Devise::RegistrationsController
	prepend_before_action :check_captcha, only: [:create, :edit] # Change this to be any actions you want to protect.

  def edit
    @user = current_user
  end

  private

  def sign_up_params
    params.require(:user).permit(:username, :email, :password, :password_confirmation, :role)
  end

  def account_update_params
    params.require(:user).permit(:email, :password, :password_confirmation, :current_password)
  end

  def check_captcha
    unless verify_recaptcha
      self.resource = resource_class.new sign_up_params
      resource.validate # Look for any other validation errors besides Recaptcha
      respond_with_navigational(resource) { render :new }
    end 
  end
end