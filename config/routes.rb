AdvertisingPlatform::Application.routes.draw do
  root 'campaigns#index'
  resources :campaigns, only: [:index, :new, :create, :show] do
    get 'counter_clicks', on: :member
    get 'get_banner', on: :collection
  end
end
