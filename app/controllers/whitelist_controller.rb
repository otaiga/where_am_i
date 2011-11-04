class WhitelistController < ApplicationController
	def index
		@whitelist = Whitelist.all
	end

  def create
  	@whitelist = Whitelist.create(friend: params[:friend], number: params[:number], user_id: current_user.id)
    redirect_to '/'
  end

  def destroy
    @whitelist = Whitelist.destroy(params[:format])
    redirect_to '/'
  end

  def edit
  	 @whitelist = Whitelist.find(params[:format])

  end

  def modify
      a = params[:post][:id]
      mod = Whitelist.find(a)
      mod.update_attributes(:friend => params[:post][:friend], :number => params[:post][:number])
      redirect_to '/'
  end
end
