class CounterWorker < ApplicationController
  include Sidekiq::Worker

  def perform(campaign_id, attribute)
    @campaign = Campaign.find(campaign_id)
    @campaign.increment(attribute).save
    PrivatePub.publish_to("/messages/#{@campaign.id}", message: {clicks: @campaign.clicks, shows: @campaign.shows})
  end
end