class RegistrationsController < Devise::RegistrationsController
  before_action :authenticate_user!
  before_action :is_admin, only: [:new, :create, :cancel]
  skip_before_action :require_no_authentication, only: [:new, :create, :cancel]

  def new
    # super
    # @user = User.new
    # @user.build_subscription
    build_resource({})
    self.resource.subscription = Subscription.new
    respond_with self.resource
  end

  def cancel
    @user = User.find(params[:user_id])
    if @user.is_active?
      @user.update(is_active: false)
    else
      @user.update(is_active: true)
    end
    redirect_to users_path
  end

  def create
    # super 
    build_resource(sign_up_params)

    resource.save
    yield resource if block_given?
    if resource.persisted?
      # if resource.active_for_authentication?
      #   set_flash_message! :notice, :signed_up
      #   # sign_up(resource_name, resource)
      #   respond_with resource, location: after_sign_up_path_for(resource)
      # else
        set_flash_message! :notice, :"signed_up_but_#{resource.inactive_message}"
        expire_data_after_sign_in!
        respond_with resource, location: after_inactive_sign_up_path_for(resource)
      # end
    else
      clean_up_passwords resource
      set_minimum_password_length
      respond_with resource
    end
    # @user = User.new(user_params)
    # logger.debug user_params.inspect

   
    # respond_to do |format|
    #   if @user.save
    #     format.html { redirect_to users_path, notice: 'User was successfully created.' }
    #     format.json { head :no_content }
    #   else
        
    #     format.html { redirect_to new_user_registration_path }
    #     format.json { render json: @user.errors, status: :unprocessable_entity }
    #   end

  end

  def update
    if user_params[:password].blank?
      user_params.delete[:password]
      user_params.delete[:passowrd_confirmaton]
    end

    successfully_updated =  if needs_password?(@user, user_params)
                              @user.update(user_params)
                            else
                              @user.update_without_password(user_params)
                            end
    respond_to do |format|
      if successfully_updated
        format.html { redirect_to root_path, notice: 'User was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    
    @user = User.find(params[:user_id])
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_path, notice: 'User successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def is_admin
    return unless !current_user.admin?
    redirect_to root_path, alert: 'Admins only!'
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def user_params
    params.require(:user).permit(:email, :fullname, :password, :password_confirmation)
  end
  # def user_params
  #   allow = [:fullname, :email, :password, :password_confirmation,  [subscription_attributes: [:user_id, :name, :total, :date_expired_at]]]
  #   params.require(resource_name).permit(allow)
  # end

  # https://kakimotonline.com/2014/03/30/extending-devise-registrations-controller/
  def sign_up_params
    allow = [:fullname, :email, :password, :password_confirmation,  [subscription_attributes: [ :name, :total, :date_expired_at]]]
    params.require(resource_name).permit(allow)
  end

  def set_user
    @user = User.includes(:subscription).find(params[:id])
  end

  # https://github.com/plataformatec/devise/wiki/How-To%3a-Allow-users-to-edit-their-account-without-providing-a-password
  def needs_password?(user, params)
    params[:password].present?
  end
end
