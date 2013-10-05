class AddOrganizerIdToCampaigns < ActiveRecord::Migration
  def change
    add_column :campaigns, :organizer_id, :integer
  end
end
