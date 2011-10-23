class WhitelistController < ApplicationController
	def index
		@whitelist = Whitelist.all
	end
  def create
    puts "hello create!!!!"
  	@whitelist = Whitelist.new(params[:whitelist])
	  if @whitelist.save
      redirect_to('/', :notice => "We will get back to you as soon as possible...")
    else
      redirect_to('/', :alert => "Hey, sorry but something went wrong")
    end
  end

  def destroy
  end

  def edit
  	 @whitelist = Whitelist.find(params[:format])

  end

end
