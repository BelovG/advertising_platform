class CampaignsController < ApplicationController

  respond_to :json, :xml

  def index
    @campaigns = Campaign.all
  end

  def new
    @campaign = Campaign.new
  end

  def create
    @campaign = Campaign.create(campaign_params)
    if @campaign.errors.empty?
      redirect_to campaigns_path
    else
      render "new"
    end
  end

  def show
    @campaign = Campaign.find_by_id(params[:id])
    unless @campaign
      render text: "Page not found", status: 404
    end
  end

  def get_banner
    @campaigns = Rails.cache.fetch('campaigns', expires_in: 60.minutes) do
      Campaign.find(Campaign.all.pluck(:id).sample(50))
    end
  end

  def counter_shows
    CounterWorker.perform_async(params[:id], :shows)
    render json: {status_counter: "Ok"}.to_json, callback: params[:callback]
  end

  def counter_clicks
    CounterWorker.perform_async(params[:id], :clicks)
    render json: {status_counter: "Ok"}.to_json, callback: params[:callback]
  end

  private

  def campaign_params
    params.require(:campaign).permit(:name, :url, :banner)
  end
end
