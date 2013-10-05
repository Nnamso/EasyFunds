class HomeController < ApplicationController

  def index
  	@campaigns = Campaign.where(:status => false)

  	respond_to do |format|
    	format.html # index.html.erb
    	format.json  { render :json => @campaigns }
  end

  end


end
