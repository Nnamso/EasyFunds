class CampaignController < ApplicationController
  def view
    @campaign = Campaign.find(params[:id])

    @donation = Donation.new
  end

  def request_checkout
    @donation = Donation.new(params[:donation])

    @donation.campaign = Campaign.find(params[:id])

    if @donation.valid?

      invoice = MPower::Checkout::Invoice.new
      invoice.add_item(@donation.campaign.title,1,@donation.amount,@donation.amount);
      invoice.description = "Donation to support " + @donation.campaign.title;
      invoice.total_amount = @donation.amount.to_f
      invoice.add_custom_data("CampaignID",@donation.campaign.id);
      invoice.return_url = confirm_url(@campaign)
      invoice.create
      redirect_to invoice.invoice_url

    else
      render 'view'
    end
  end

  def confirm
    token = params[:token]

    invoice = MPower::Checkout::Invoice.new
    if invoice.confirm(token)

      @donation = Donation.new
      @donation.amount = invoice.total_amount
      @donation.name = invoice.get_customer_info "name"
      @donation.mpower_email = invoice.get_customer_info "email"
      @donation.mpower_phone = invoice.get_customer_info "phone"
      @donation.campaign = Campaign.find(invoice.get_custom_data "CampaignID")
      @donation.save
      flash[:notice] = "Thank you, " + @donation.name + " for supporting " + @donation.campaign.title + " with " + @donation.amount.to_f.to_s + " GHS!"
      redirect_to root_url
    end

  end
end
