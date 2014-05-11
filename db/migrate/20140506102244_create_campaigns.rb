class CreateCampaigns < ActiveRecord::Migration
  def change
    create_table :campaigns do |t|
      t.string :name, null: false
      t.string :url, null: false
      t.integer :shows, null: false, default: 0
      t.integer :clicks, null: false, default: 0
      t.timestamps
    end
  end
end
