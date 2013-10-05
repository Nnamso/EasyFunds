class AddCampaignIdToDonations < ActiveRecord::Migration
  def change
    add_column :donations, :campaign_id, :integer
  end
end
