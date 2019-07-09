class NotificationsController < ApplicationController
  def index
    unless current_user
      return redirect_to root_path
    end
    @notifications = Notification.where(user: current_user)
    @notifications.each do |notification| notification.delete end
  end
end
