class CreateCampaigns < ActiveRecord::Migration
  def change
    create_table :campaigns do |t|
      t.string :title
      t.text :description
      t.decimal :amount
      t.date :date_due
      t.boolean :status

      t.timestamps
    end
  end
end
