class Campaign < ActiveRecord::Base
  attr_accessible :amount, :date_due, :description, :status, :title, :organizer_id, :image_url

  belongs_to :organizer
  has_many :donations

  after_save :perform_transfers

  def total_donations
    self.donations.map(&:amount).sum.to_f
  end

  def self.check_expiration
    campaign = where(status: false)
    campaign.each do |campaign|
      if campaign.date_due  <= DateTime.now
        campaign.status = true
        campaign.save
      end
    end
  end

  def perform_transfers
    puts "perform transfer"
    if (self.status == true)
      direct_pay = MPower::DirectPay.new

      self.donations.each do |donation|

        if self.total_donations < amount
          direct_pay.credit_account(donation.mpower_email,donation.amount.to_f)
          SmsghSms.push(:to => donation.mpower_phone, :msg => "Hello " + donation.name + ", Unfortunately, the target for " + donation.campaign.title + " wasn't reached. " + donation.amount.to_f.to_s + " GHS was refunded back to your MPower account.")
        else
          direct_pay.credit_account(donation.mpower_email,donation.amount.to_f)
          SmsghSms.push(:to => donation.mpower_phone, :msg => "Hello " + donation.name + ", Thank you for your donation to support " + donation.campaign.title + ". The total amount raised was " + self.total_donations.to_f.to_s + " GHS.")
        end

      end

      if self.total_donations < amount
        SmsghSms.push(:to => donation.campaign.organizer.phone, :msg => "Hello " + donation.campaign.organizer.name + ", Unfortunately, the target for " + donation.campaign.title + " wasn't reached. " + self.total_donations.to_f.to_s + "GHS out of " + donation.campaign.amount.to_f.to_s + " was raised and all donors were refunded.")
      end

    end
  end
  handle_asynchronously :perform_transfers

end
