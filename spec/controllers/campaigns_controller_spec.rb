require 'spec_helper'
require 'sidekiq/testing'
Sidekiq::Testing.inline!

describe CampaignsController do

  describe "create action" do
    it "redirects to campaigns_path if validations pass" do
      post :create, campaign: { name: "Name", url: "https://vk.com/george.belov" }
      expect(response).to redirect_to(campaigns_path)
    end

    it "renders new page if validations fail" do
      post :create, campaign: { name: nil, url: nil }
      expect(response).to render_template('new')
    end
  end

  describe "show action" do
    it "renders show template if an campaign is found" do
      campaign = create(:campaign)
      get :show, id: campaign.id
      expect(response).to render_template('show')
    end

    it "renders 404 page if an campaign is not found" do
      get :show, id: "0"
      expect(response.status).to eq(404)
    end
  end

  describe "get_banner action" do
    it "if cache exist" do
      100.times {create(:campaign)}
      Rails.cache.write( :campaigns, Campaign.all.sample(100), expires_in: 60*60)
      get :get_banner
      expect(assigns(:campaigns)).to eq(Rails.cache.read(:campaigns))
    end

    it "if cache empty" do
      Rails.cache.delete(:campaign)
      get :get_banner
      expect(Rails.cache.read(:campaigns)).to eq(assigns(:campaigns))
    end
  end

  def self.counter(action, field)
    it "#{action}" do
      campaign = create(:campaign, shows: 0, clicks: 0)
      get action, id: campaign.id
      expect(campaign.reload.public_send(field)).to eq(1)
    end
  end

  counter :counter_shows, 'shows'
  counter :counter_clicks, 'clicks'
end
