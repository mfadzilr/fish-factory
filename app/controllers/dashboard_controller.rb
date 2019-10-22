class DashboardController < ApplicationController
  before_action :authenticate_user!
  def index
    @campaigns = current_user.campaigns.order('id DESC'
      ).paginate(page: params[:page], per_page: 5)
  end
end
