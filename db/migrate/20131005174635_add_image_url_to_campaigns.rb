class AddImageUrlToCampaigns < ActiveRecord::Migration
  def change
    add_column :campaigns, :image_url, :string
  end
end
