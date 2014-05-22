class CounterWorker < ApplicationController
  include Sidekiq::Worker
  #include Sync::Actions

  def perform(campaign_id, attribute)
    @campaign = Campaign.find(campaign_id)
    @campaign.increment(attribute).save
    render "/campaigns/_reload.js.erb"
    #sync_update @campaign
  end
end