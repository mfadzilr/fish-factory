class RecipientDetailsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_campaign, only: [:index, :show]

  def index
    if params[:search].present?
      @recipients = Recipient.where(id: @campaign.responses.joins(:recipient_details).distinct.pluck(:recipient_id)).where('LOWER(full_name) LIKE ? OR LOWER(email_to) LIKE ?', "%#{params[:search]}%", "%#{params[:search]}%").paginate(page: params[:page], per_page: 25)
    else
      @recipients = Recipient.where(id: @campaign.responses.joins(:recipient_details).distinct.pluck(:recipient_id)).paginate(page: params[:page], per_page: 25)
    end
  end

  def show
    @recipient_detail = RecipientDetail.where(campaign_id: params[:campaign_id]).find(params[:id])
  end

  private

  def set_campaign
    @campaign = current_user.campaigns.find(params[:campaign_id])
  end
end
