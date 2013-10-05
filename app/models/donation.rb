class Donation < ActiveRecord::Base
  attr_accessible :amount, :mpower_email, :mpower_phone, :name, :campaign_id

  validates :amount, :presence => true

  belongs_to :campaign
end
