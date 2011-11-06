class MainController < ApplicationController
  def index
  	if user_signed_in?
  	@user = User.find(current_user.id)
  	@whitelist = @user.whitelists.all
  else
  	redirect_to new_user_session_path
  end
end
end