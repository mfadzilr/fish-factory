class TestMailer < ApplicationMailer

	def send_testemail(params, current_user) 

	    settings = {
	        :address => params[:send_profile][:address],
	        :port =>  params[:send_profile][:port],
	        :user_name =>  params[:send_profile][:user_name],
	        :password => params[:send_profile][:password],
	        :authentication => params[:send_profile][:authentication]
	      }

	    mail  delivery_method_options: settings,
	          to: current_user.email,
	          from: params[:send_profile][:user_name],
	          subject:'This is a test email' do |format|
	            format.text { render plain: 'Hi, this a test email' }
	      	end

	end

	def is_a_valid_email?(email)
	  (email =~ /^(([A-Za-z0-9]*\.+*_+)|([A-Za-z0-9]+\-+)|([A-Za-z0-9]+\+)|([A-Za-z0-9]+\+))*[A-Z‌​a-z0-9]+@{1}((\w+\-+)|(\w+\.))*\w{1,63}\.[a-zA-Z]{2,4}$/i)
	end
end
