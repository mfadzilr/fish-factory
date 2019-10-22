class CampaignTestMailer < ApplicationMailer
	def send_testcampaignemail(params, current_user) 
		recipient_email = current_user.email
		sender_name = params[:campaign][:sender_name]
		sender_email = params[:campaign][:sender_email]
		sender_subject = params[:campaign][:sender_subject]
		send_profile_id =  params[:campaign][:send_profile_id]
		email_template_id = params[:campaign][:email_template_id]
		site_page_id = params[:campaign][:site_page_id]
		site_address = params[:campaign][:site_address]

		if !self.is_a_valid_email?(sender_email) 
			raise 'Sender Email is invalid'
		end
		if sender_name.nil? || sender_name.empty?
			raise 'Sender Name can\'t be blank'
		end
		if sender_email.nil? || sender_email.empty?
			raise 'Sender Email can\'t be blank'
		end
		if recipient_email.nil? || recipient_email.empty?
			raise 'Recipient Email can\'t be blank'
		end
		if sender_subject.nil? || sender_subject.empty?
			raise 'Sender Subject can\'t be blank'
		end

		sender_subject = sender_subject.gsub /{{USER}}/i, current_user.fullname

		if sender_subject.nil? || sender_subject.empty?
			sender_subject = 'This is a test email'
		end

		name, domain = sender_email.split("@")
		headers['Message-ID'] = "#{SecureRandom.hex()[0..9]}.#{SecureRandom.hex()[0..7]}-#{SecureRandom.hex()[0..9]}.#{SecureRandom.hex()[0..7]}-#{SecureRandom.random_number(9999999999999)}@#{domain}"

		email_from_with_name = %("#{sender_name}" <#{sender_email}>)
		smtp_settings = SendProfile.find(send_profile_id) rescue nil
		email_template = EmailTemplate.find(email_template_id)

		if smtp_settings.nil?
			raise 'Invalid Send Profile. Please select a valid Send Profile'
		end
		if email_template.nil?
			raise 'Invalid Email Template'
		end
		if email_template.nil?
			raise 'Invalid Email Template'
		end
		if site_address.present?
	      phishing_site_url = site_address
	    else
	      phishing_site_url = root_url
	    end

		content = email_template.content
		content = content.gsub /{{USER}}/i, current_user.fullname
	    content = content.gsub /{{DOMAIN}}/i, domain
	    content = content.gsub /{{PHISH_URL}}/i, %(<a href="#{phishing_site_url + 'links/' + 'testonly'}"><u>here</u></a>)
	    content = content.gsub /{{PHISH_RAW_URL}}/i, %(#{phishing_site_url + 'links/' + 'testonly'})
    	content = content.gsub /{{SITE_URL}}/i, %(#{phishing_site_url})

	    settings = {
	        :address => smtp_settings.address,
	        :port => smtp_settings.port,
	        :user_name => smtp_settings.user_name,
	        :password => smtp_settings.password,
	        :authentication => smtp_settings.authentication
	      }

	    mail  delivery_method_options: settings,
	          to: recipient_email,
	          from: email_from_with_name,
	          subject:sender_subject do |format|
	            format.html { render plain: content }
	      	end

	    

	end

	

	def is_a_valid_email?(email)
	  (email =~ /^(([A-Za-z0-9]*\.+*_+)|([A-Za-z0-9]+\-+)|([A-Za-z0-9]+\+)|([A-Za-z0-9]+\+))*[A-Z‌​a-z0-9]+@{1}((\w+\-+)|(\w+\.))*\w{1,63}\.[a-zA-Z]{2,4}$/i)
	end
end
