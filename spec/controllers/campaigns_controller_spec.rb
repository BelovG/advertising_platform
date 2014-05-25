require 'spec_helper'
#require 'sidekiq/testing'
#Sidekiq::Testing.inline!

describe CampaignsController do

  describe "index action" do
    it "populates an array of campaigns" do
      campaign = create(:campaign)
      get :index
      expect(assigns(:campaigns)).to eq([campaign])
    end

    it "renders the :index view" do
      get :index
      expect(response).to render_template('index')
    end
  end

  describe "new action" do
    it "initializes campaign" do
      get :new
      expect(assigns(:campaign).present?).to eq(true)
    end

    it "renders the :new view" do
      get :new
      expect(response).to render_template('new')
    end
  end

  describe "create action" do
    context "with valid attributes" do
      it "creates a new campaign" do
        expect{
          post :create, campaign: attributes_for(:campaign)
        }.to change(Campaign,:count).by(1)
      end

      it "redirects to campaigns_path" do
        post :create, campaign: attributes_for(:campaign)
        expect(response).to redirect_to(campaigns_path)
      end
    end

    context "with invalid attributes" do
      it "does not save the new campaign" do
        expect{
          post :create, campaign: attributes_for(:campaign, name: nil, url: nil)
        }.to_not change(Campaign,:count)
      end

      it "renders new page" do
        post :create, campaign: attributes_for(:campaign, name: nil, url: nil)
        expect(response).to render_template('new')
      end
    end
  end

  describe "show action" do
    it "assigns the requested campaign" do
      campaign = create(:campaign)
      get :show, id: campaign.id
      expect(assigns(:campaign)).to eq(campaign)
    end

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
      50.times {create(:campaign)}
      Rails.cache.write( :campaigns, Campaign.find(Campaign.all.pluck(:id).sample(50)), expires_in: 60*60)
      get :get_banner
      expect(assigns(:campaigns)).to eq(Rails.cache.read(:campaigns))
    end

    it "if cache empty" do
      Rails.cache.delete(:campaign)
      get :get_banner
      expect(Rails.cache.read(:campaigns)).to eq(assigns(:campaigns))
    end
  end

  describe "counter_shows" do
    it "renders json" do
      campaign = create(:campaign)
      allow(CounterWorker).to receive(:perform_async).with(campaign.id.to_s, :shows) { }
      get :counter_shows, id: campaign.id
      json = JSON.parse(response.body)
      expect(json['status_counter']).to eq("Ok")
    end
  end

  describe "counter_clicks" do
    it "renders json" do
      campaign = create(:campaign)
      allow(CounterWorker).to receive(:perform_async).with(campaign.id.to_s, :clicks) { }
      get :counter_clicks, id: campaign.id
      json = JSON.parse(response.body)
      expect(json['status_counter']).to eq("Ok")
    end
  end

  describe "CounterWorker" do
    it "increases :shows" do
      campaign = create(:campaign)
      worker = CounterWorker.new
      allow(PrivatePub).to receive(:publish_to).with("/messages/#{campaign.id}", message: {clicks: 0, shows: 1}) { }
      worker.perform(campaign.id, :shows)
      expect(campaign.reload.shows).to eq(1)
    end

    it "increases :clicks" do
      campaign = create(:campaign)
      worker = CounterWorker.new
      allow(PrivatePub).to receive(:publish_to).with("/messages/#{campaign.id}", message: {clicks: 1, shows: 0}) { }
      worker.perform(campaign.id, :clicks)
      expect(campaign.reload.clicks).to eq(1)
    end
  end
end
