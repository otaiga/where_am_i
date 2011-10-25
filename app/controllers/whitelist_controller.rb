class WhitelistController < ApplicationController
	def index
		@whitelist = Whitelist.all
	end

  def create
  	@whitelist = Whitelist.create(friend: params[:friend], number: params[:number], user_id: params[:user_id])
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
    # @whitelist = Whitelist.update_attributes
  end
end
