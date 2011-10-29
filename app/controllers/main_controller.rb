class MainController < ApplicationController
  def index
  	@whitelist = Whitelist.all
end
end