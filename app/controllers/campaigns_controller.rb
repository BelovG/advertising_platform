class CampaignsController < ApplicationController

  respond_to :json, :xml

  def index
    @campaigns = Campaign.all
  end

  def new
    @campaign = Campaign.new
  end

  def create
    @campaign = Campaign.new(campaign_params)
    if @campaign.save
      redirect_to campaigns_path
    else
      render "new"
    end
  end

  def show
    @campaign = Campaign.find(params[:id])
  end

  def get_banner
    if Rails.cache.exist?(:campaigns)
      @campaigns = Rails.cache.read(:campaigns)
    else
      @campaigns = Campaign.all.sample(100)
      Rails.cache.write( :campaigns, @campaigns, expires_in: 60*60)
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
