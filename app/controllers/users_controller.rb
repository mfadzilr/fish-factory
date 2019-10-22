class UsersController < ApplicationController
  before_action :is_admin

  def index
    @users = User.includes(:subscription).all.paginate(page: params[:page], per_page: 5)
  end

  private

  def is_admin
    return unless !current_user.admin?
    redirect_to root_path, alert: 'Admins only!'
  end

  # before_action :is_admin, only: [:new, :create]
  # # skip_before_filter :require_no_authentication, only: [:new, :create]
  #
  # def index
  #   @users = User.all
  # end
  #
  # def edit
  #   @user = User.find(current_user)
  # end
  #
  # def new
  #   # super
  #   @user = User.new
  # end
  #
  # def create
  #   @user = User.new(user_params)
  #   respond_to do |format|
  #     if @user.save
  #       format.html { redirect_to users_path, notice: 'User was successfully created.' }
  #       format.json { head :no_content }
  #     else
  #       format.html { redirect_to new_user_registration_path }
  #       format.json { render json: @user.errors, status: :unprocessable_entity }
  #     end
  #   end
  #
  # end
  #
  # def update
  #   if user_params[:password].blank?
  #     user_params.delete[:password]
  #     user_params.delete[:passowrd_confirmaton]
  #   end
  #
  #   successfully_updated =  if needs_password?(@user, user_params)
  #                             @user.update(user_params)
  #                           else
  #                             @user.update_without_password(user_params)
  #                           end
  #   respond_to do |format|
  #     if successfully_updated
  #       format.html { redirect_to root_path, notice: 'User was successfully updated.' }
  #       format.json { head :no_content }
  #     else
  #       format.html { render action: 'edit' }
  #       format.json { render json: @user.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end
  #
  # private
  #
  # def is_admin
  #   return unless !current_user.admin?
  #   redirect_to root_path, alert: 'Admins only!'
  # end
  #
  # # Never trust parameters from the scary internet, only allow the white list through.
  # def user_params
  #   params.require(:user).permit(:email, :password, :password_confirmation)
  # end
  #
  # # https://github.com/plataformatec/devise/wiki/How-To%3a-Allow-users-to-edit-their-account-without-providing-a-password
  # def needs_password?(user, params)
  #   params[:password].present?
  # end

end
