class CampaignsController < ApplicationController

  include Sidekiq::Worker
  before_action :authenticate_user!
  before_action :set_campaign, only: [:start, :stop, :show, :edit, :update, :destroy]
  before_action :set_recipient_groups, only: [:new, :edit, :show, :create]

  def start
    if @campaign.nil?
      flash[:error] = 'Invalid campaign.'
      redirect_to root_path
      return
    end
    status = @campaign.start
    if status == -1
      flash[:error] = 'Insufficient credit. Please contact administrator.'
      redirect_to root_path
      return
    elsif status == -2
      flash[:error] = 'Campaign already in-progress.'
      redirect_to root_path
      return
    end

    PhishingJob.new(@campaign.id).enqueue(wait_until: @campaign.date_start_at)
    #CampaignStatusJob.new(@campaign.id).enqueue(wait_until: @campaign.date_start_at)

    Notification.create(:note => 'Campaign ' + @campaign.title + ' will be started as scheduled.', :user_id => @campaign.user_id)
    @campaign.update_column(:status, CAMP_QUEUED)

    flash[:success] = 'Campaign is now queued and will be processed shortly.'
    redirect_to root_path
  end

  def stop
    campaign = Campaign.find(@campaign.id)
    Response.where(campaign_id: campaign.id).update_all(status: RESP_CANCELLED)
    campaign.update_column(:status, CAMP_COMPLETED)
    flash[:success] = 'Campaign is now stopped.'
    redirect_to root_path
  end
  # GET /campaigns
  # GET /campaigns.json
  def index

    @campaigns = current_user.campaigns.reorder("status DESC").paginate(page: params[:page], per_page: 5)
    respond_to do |format|
      format.html 
      format.json { render :json => @campaigns.to_json(:only=>[:id, :title, :status, :total_completed, :total_target]) }
    end
  end

  def campaign_dashboard
    @campaigns = current_user.campaigns.order('id DESC').paginate(page: params[:page], per_page: 5)
    render layout: 'site_page'
   
  end


  # GET /campaigns/1
  # GET /campaigns/1.json
  def show
  end

  # GET /campaigns/new
  def new
    # email_templates = EmailTemplate.where("user_id = ? or is_private = ?", current_user, false)
    # site_pages = SitePage.where("user_id = ? or is_private = ?", current_user, false)
    # send_profiles = SendProfile.where("user_id = ? or public = ?", current_user, true)

    if (Recipient.where(recipient_group_id: current_user.recipient_group_ids).count == 0) 
        err_msg = 'It appears that you don\'t have any targets recipient yet. Please add your targets to Recipent Group first.'
        flash[:error] = 'It appears that you don\'t have any targets recipient yet. Please add your targets to Recipent Group first.'
        respond_to do |format|
          format.html { redirect_to campaigns_url }
          format.json { render json: { message: err_msg }, status: :unprocessable_entity }
        end
    end

    @campaign = Campaign.new
  end

  # GET /campaigns/1/edit
  def edit
  end

  # POST /campaigns
  # POST /campaigns.json
  def create
    @campaign = current_user.campaigns.build(campaign_params) do |t|
      
    end

    respond_to do |format|
      if @campaign.save
        format.html { redirect_to @campaign, notice: 'Campaign was successfully created.' }
        format.json { render json: { message: 'New Campaign successfully saved.'}, status: :created }
      else
        format.html { render :new }
        format.json { render json: @campaign.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /campaigns/1
  # PATCH/PUT /campaigns/1.json
  def update
    respond_to do |format|
      if @campaign.update(campaign_params)
        format.html { redirect_to @campaign, notice: 'Campaign was successfully updated.' }
        format.json { render json: { message: 'Campaign was successfully updated.'}, status: :ok }
      else
        format.html { render :edit }
        format.json { render json: @campaign.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /campaigns/1
  # DELETE /campaigns/1.json
  def destroy
    @campaign.destroy
    url = URI(request.referer).path == '/' ? root_path : campaigns_url
    respond_to do |format|
      format.html { redirect_to url, notice: 'Campaign was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def testemail
    render layout: 'site_page'
  end

  def testemailnow

    # begin
    #   TestMailer.send_testemail(params[:campaign][:sender_name],params[:campaign][:sender_email],params[:campaign][:email],params[:campaign][:send_profile_id]).deliver_now
    #   respond_to do |format|
    #     format.json { render json: { message: 'Send success' }, status: :ok }
    #   end
    # rescue StandardError,
    #   Exception,
    #   IOError,
    #   Net::SMTPAuthenticationError,
    #   Net::SMTPServerBusy,
    #   Net::SMTPUnknownError,
    #   Net::SMTPFatalError,
    #   TimeoutError,
    #   Net::SMTPFatalError, 
    #   Net::SMTPSyntaxError,
    #   OpenSSL::SSL::SSLError => e
    #   respond_to do |format|
    #     format.json { render json: { message: e.class.to_s + ' : ' + e.message }, status: :unprocessable_entity }
    #   end

    # end
  end

  def testcampaignemailnow
    begin
      CampaignTestMailer.send_testcampaignemail(params, current_user).deliver_now
      respond_to do |format|
        Notification.create(:note => 'Campaign test email was sent successfully', :user_id => current_user.id)
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
        Notification.create(:note => 'Failed to send campaign test email', :user_id => current_user.id)
        format.json { render json: { message: e.class.to_s + ' : ' + e.message }, status: :unprocessable_entity }
      end

    end

  end

  private

    def set_recipient_groups
      @recipient_groups = current_user.recipient_groups
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_campaign
      @campaign = current_user.campaigns.find(params[:id]) rescue nil
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def campaign_params
      params.fetch(:campaign, {}).permit(:title, :description, :site_address, :sender_name, :sender_email, :sender_subject, :date_start_at, :date_end_at, :attach_file, :email_template_id, :site_page_id, :attachment_file_id, :send_profile_id, :recipient_group_ids => [])
    end
end
