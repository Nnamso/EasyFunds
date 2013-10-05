class HomeController < ApplicationController

  def index
  	@campaigns = Campaign.where(:status => false)
  end
end
