class Organizer < ActiveRecord::Base
  attr_accessible :address, :email, :name, :phone

  has_many :campaigns
end
