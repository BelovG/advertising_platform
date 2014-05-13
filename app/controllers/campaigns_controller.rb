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
    @campaign = Campaign.all.sample
    if @campaign.increment(:shows).save
      sync_update @campaign.reload
    end
  end

  def counter_clicks
    @campaign = Campaign.find(params[:id])
    if @campaign.increment(:clicks).save
      sync_update @campaign
      render json: {status: "Ok"}.to_json, callback: params[:callback]
    end
  end

  private

  def campaign_params
    params.require(:campaign).permit(:name, :url, :banner)
  end

end
