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

        amount_raised = self.donations.map(&:amount).sum

        org_message = ""

        if amount_raised < amount
            @donations = self.donations

            for donation in @donations
                #pay back donors
                direct_pay = MPower::DirectPay.new
                if (direct_pay.credit_account(donation.mpower_email,donation.amount.to_f))
                    SmsghSms.push(:to => donation.mpower_phone, :msg => "Hello " + donation.name + ", Unfortunately, the target for " + donation.campaign.title + " wasn't reached. " + donation.amount.to_f.to_s + " GHS was refunded back to your MPower account.")
                else
                #puts direct_pay.description
                #puts direct_pay.response_text
                end
            end

        org_message = "Hello " + donation.campaign.organizer.name + ", Unfortunately, the target for " + donation.campaign.title + " wasn't reached. " + amount_raised.to_f.to_s + "GHS out of " + donation.campaign.amount.to_f.to_s + " was raised and all donors were refunded."
        
        SmsghSms.push(:to => donation.campaign.organizer.phone, :msg => org_message)

        else
          direct_pay = MPower::DirectPay.new
          if (direct_pay.credit_account(self.organizer.email,amount_raised.to_f))
            
            org_message = "Hello " + self.organizer.name + ", Congratulations, the target for " + self.title + " was reached. " + amount_raised.to_f.to_s + "GHS  was raised in total and your MPower was credited with the amount raised."
            
             SmsghSms.push(:to => self.organizer.phone, :msg => org_message)

            @donations = self.donations

             for donation in @donations
                #pay back donors
                direct_pay = MPower::DirectPay.new
                if (direct_pay.credit_account(donation.mpower_email,donation.amount.to_f))
                    SmsghSms.push(:to => donation.mpower_phone, :msg => "Hello " + donation.name + ", Thank you for your donation to support " + donation.campaign.title + ". The total amount raised was " + amount_raised.to_f.to_s + " GHS.")
                else
              
                end
            end
          else

          end

       
        end

    end
  end
  handle_asynchronously :perform_transfers

end
