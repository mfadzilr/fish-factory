class SendProfilesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_send_profile, only: [:show, :show_modal, :edit, :edit_modal, :update, :destroy]
  
  def new
    @send_profile = SendProfile.new
  end

  def new_modal
    @send_profile = SendProfile.new
    render layout: 'site_page'
  end

  def create
    @send_profile = current_user.send_profiles.build(send_profile_params)
    respond_to do |format|
      if @send_profile.save
        flash[:success] = 'Send profile was successfully created.'
        format.html { redirect_to send_profiles_path }
        format.json { render json: { message: 'Profile successfully saved.' }, status: :ok}
      else
        format.html { render :new }
        format.json { render json: @send_profile.errors.full_messages, status: :unprocessable_entity }
      end
    end
  end

  def sendtestemail
    begin
      TestMailer.send_testemail(params, current_user).deliver_now
      respond_to do |format|
        Notification.create(:note => 'Test email was sent successfully', :user_id => current_user.id)
        format.json { render json: { message: 'Test email was sent successfully.' }, status: :ok }
      end
    rescue StandardError,
      Exception,
      IOError,
      Net::SMTPAuthenticationError,
      Net::SMTPServerBusy,
      Net::SMTPUnknownError,
      Net::SMTPFatalError,
      TimeoutError,
      Net::SMTPFatalError, 
      Net::SMTPSyntaxError,
      OpenSSL::SSL::SSLError => e
      respond_to do |format|
        Notification.create(:note => 'Failed to send test email', :user_id => current_user.id)
        format.json { render json: { message: e.class.to_s + ' : ' + e.message }, status: :unprocessable_entity }
      end

    end
  end

  def update
    
    respond_to do |format|
      if @send_profile.update(send_profile_params)
        format.html { redirect_to send_profiles_path, notice: 'Send profile was successfully updated.' }
        format.json { render json: { message: 'Profile successfully saved.' }, status: :ok}
      else
        format.html { render :edit }
        format.json { render json: @send_profile.errors.full_messages, status: :unprocessable_entity }
      end
    end
  end

  def edit
  end

  def edit_modal
    render layout: 'site_page'
  end

  def destroy
    if current_user.admin? || current_user.id == @send_profile.user_id
      @send_profile.destroy
    end

    respond_to do |format|
      format.html { redirect_to send_profiles_url, notice: 'Send profile was successfully deleted.' }
      format.json { head :no_content }
    end
  end

  def index
    @send_profiles = SendProfile.where("user_id = ? or public = ?", current_user, true).paginate(page: params[:page], per_page: 5)
    @send_profiles = SendProfile.where("user_id = ?", current_user).paginate(page: params[:page], per_page: 5)
  end

  def show
  end

  def show_modal
    render layout: 'site_page'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_send_profile
      @send_profile = current_user.send_profiles.find(params[:id])
      #@send_profile = SendProfile.find("(user_id = ? or public = ?) and id = ?", current_user, true, params[:id])
    end

    def send_profile_params
      params.fetch(:send_profile, {}).permit(:title, :address, :port, :user_name, :password, :authentication, :enable_starttls_auto, :openssl_verify_mode, :public)
    end

end
