class ApplicationController < ActionController::Base
	# before_action :authenticate_user!, except: [:open_image, :open_url, :open_submit]
	protect_from_forgery with: :exception, prepend: true, except: [:open_submit]
	# layout 'layout', only: [:open_image, :open_url, :open_submit]
	include Constants

	def current_user
  		current_user ||= super && User.includes(:subscription).includes(:unread_notifications).find(@current_user.id)
	end
end
