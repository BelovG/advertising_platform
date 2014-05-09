class AddBannerColumnToCampaigns < ActiveRecord::Migration
  def self.up
    add_attachment :campaigns, :banner
  end

  def self.down
    remove_attachment :campaigns, :banner
  end
end
