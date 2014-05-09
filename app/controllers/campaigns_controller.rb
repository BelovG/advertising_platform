class CampaignsController < ApplicationController

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
    id = Random.rand(1..Campaign.count)
    @campaign = Campaign.find(id)
    #binding.pry

    render json:  { image_url: @campaign.banner.url(:medium), url: @campaign.url }
    #render :nothing => true
    #respond_to do |format|
    ##  format.js { render :content_type => 'text/javascript', :layout => false}
    #  format.xml { render :xml => @campaign.to_xml }
    #end
  end

  def counter_clicks

  end

  private

  def campaign_params
    params.require(:campaign).permit(:name, :url, :banner)
  end
end
