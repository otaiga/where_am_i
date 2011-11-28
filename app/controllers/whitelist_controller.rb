class WhitelistController < ApplicationController
	def index
  if user_signed_in?
		@whitelist = Whitelist.all
  else
    redirect_to new_user_session_path
  end
	end

  def create
    if user_signed_in?
  	@whitelist = Whitelist.create(friend: params[:friend], number: params[:number], user_id: current_user.id)
    redirect_to '/'
      else
    redirect_to new_user_session_path
  end
  end

  def destroy
    if user_signed_in?
    @whitelist = Whitelist.destroy(params[:format])
    redirect_to '/'
      else
    redirect_to new_user_session_path
  end
  end

  def edit
      if user_signed_in?
  	 @whitelist = Whitelist.find(params[:format])
       else
    redirect_to new_user_session_path
  end

  end

  def modify
      if user_signed_in?
      a = params[:post][:id]
      mod = Whitelist.find(a)
      mod.update_attributes(:friend => params[:post][:friend], :number => params[:post][:number])
      redirect_to '/'
        else
    redirect_to new_user_session_path
  end
  end
end
