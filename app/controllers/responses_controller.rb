class ResponsesController < ApplicationController
  before_action :authenticate_user!, except: [:open_image, :open_url, :open_submit]
  before_action :get_token

  def open_image
    # check if token is valid and not expired
    
    if @response.present? && DateTime.now < @response.expired_at
      ug = UserAgent.parse(request.user_agent)
      RecipientDetail.create(
        request_type: 1,
        campaign_id:  @response.campaign_id,
        recipient_id: @response.recipient_id,
        response_id:  @response.id,
        ip_address:   request.remote_ip,
        user_agent:   request.user_agent,
        browser: ug.browser == nil ? 'Unknown' : ug.browser,
        browser_version: ug.version == nil ? 'Unknown' : ug.version,
        platform: ug.platform == nil ? 'Unknown' : ug.platform,
      )
      send_file 'public/logo.jpg', type: 'image/jpeg', disposition: 'inline'
    end
  end

  def open_url
    # check if token is valid and not expired
    if @response.present? && DateTime.now < @response.expired_at
      ug = UserAgent.parse(request.user_agent)
      RecipientDetail.create(
        request_type: 2,
        campaign_id:  @response.campaign_id,
        recipient_id: @response.recipient_id,
        response_id:  @response.id,
        ip_address:   request.remote_ip,
        user_agent:   request.user_agent,
        browser: ug.browser == nil ? 'Unknown' : ug.browser,
        browser_version: ug.version == nil ? 'Unknown' : ug.version,
        platform: ug.platform == nil ? 'Unknown' : ug.platform,
      )

      content = SitePage.redirect_form_action(
        SitePage.find(Campaign.find(
          @response.campaign_id).site_page_id).content,
          @response.token,
          root_url
        )
      render html: content.html_safe
    else
      #render html: 'Token Expired'
      raise ActionController::RoutingError.new('Not Found')
    end
  end

  def open_submit
    # check if token is valid and not expired
    if @response.present? && DateTime.now < @response.expired_at
      ug = UserAgent.parse(request.user_agent)
      RecipientDetail.create(
        request_type: 3,
        campaign_id:  @response.campaign_id,
        recipient_id: @response.recipient_id,
        response_id:  @response.id,
        ip_address:   request.remote_ip,
        user_agent:   request.user_agent,
        browser: ug.browser == nil ? 'Unknown' : ug.browser,
        browser_version: ug.version == nil ? 'Unknown' : ug.version,
        platform: ug.platform == nil ? 'Unknown' : ug.platform,
        data: params.to_json,
      )
    end
  end

  private

  def get_token
    @response = Response.find_by_token(params[:token])
  end
end
