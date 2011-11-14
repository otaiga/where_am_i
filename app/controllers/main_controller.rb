class MainController < ApplicationController
  def index
  	if user_signed_in?
  	@user = User.find(current_user.id)
  	@whitelist = @user.whitelists.all
  else
  	redirect_to new_user_session_path
  end
end

def loop_on
  @user = User.find(current_user.id)
  if @user.auths == []
  	puts "Must have authenticated first"
  	redirect_to root_path
  else
  	mod = @user.auths.first
    mod.update_attributes(run_flag: true) 
    redirect_to root_path
  end
end

  def loop_off
  @user = User.find(current_user.id)
  if @user.auths == []
  	puts "Must have authenticated first"
  	redirect_to root_path
  else
  	mod = @user.auths.first
    mod.update_attributes(run_flag: false) 
    redirect_to root_path
  end
end

end
