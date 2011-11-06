class MainController < ApplicationController
  def index
  	if user_signed_in?
  	@user = User.find(current_user.id)
  	@whitelist = @user.whitelists.all
  else
  	redirect_to "/users/sign_in"
  end
end
end