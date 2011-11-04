class MainController < ApplicationController
  def index
  	@user = User.find(current_user.id)
  	@whitelist = @user.whitelists.all
end
end