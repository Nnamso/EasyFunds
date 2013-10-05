class CreateDonations < ActiveRecord::Migration
  def change
    create_table :donations do |t|
      t.string :name
      t.string :mpower_email
      t.string :mpower_phone
      t.decimal :amount

      t.timestamps
    end
  end
end
