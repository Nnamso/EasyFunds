class Donation < ActiveRecord::Base
  attr_accessible :amount, :mpower_email, :mpower_phone, :name, :campaign_id

  validates :amount, :presence => true
  belongs_to :campaign
  validates :amount, :numericality => :true
  validates :amount, :numericality =>{:greater_than=>0, :message=>"Please enter amount greater than 0.00GHS"}

end
