class CampaignStatusJob < ApplicationJob

  queue_as :low

  def perform(campaign_id)
  	campaign = Campaign.find(campaign_id) rescue nil

  	if campaign.nil? 
  		return
  	end

  	response_created = false

  	while true
		  sleep 1
	  	if (notyet == 0) 
	  		res = Response.where("campaign_id = ?", campaign_id)
	  		if res.empty?
	  			next
		  	else
		  		notyet = 1
		  		next
		  	end
	  	end
	  

      	res = Response.where("campaign_id = ? and status <> ?", campaign_id, 1)
      	if res.empty?
			campaign.update_column(:status, CAMP_COMPLETED)
        	Notification.create(:note => 'Campaign ' + campaign.title + ' has completeddd', :user_id => campaign.user_id)
          	return
    	end
	end

  end

 end