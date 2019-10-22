Rails.application.routes.draw do

  match 'notifications' => 'notifications#readall', :via => :delete
  match 'campaigns/testemail' => 'campaigns#testemail', :via => :get
  match 'campaigns/campaign_dashboard' => 'campaigns#campaign_dashboard', :via => :get
  match 'campaigns/testemailnow' => 'campaigns#testemailnow', :via => :post
  match 'campaigns/testcampaignemailnow' => 'campaigns#testcampaignemailnow', :via => :post
  match 'campaigns/testcampaignemailnow' => 'campaigns#testcampaignemailnow', :via => :patch
  match 'send_profiles/sendtestemail' => 'send_profiles#sendtestemail', :via => :post
  match 'send_profiles/sendtestemail' => 'send_profiles#sendtestemail', :via => :patch
  
  resources :notifications 
  get '/reports/new_modal', to: 'reports#new_modal'
  resources :reports do
    member do
      get :export
      get 'edit_modal'
    end
  end
  
  resources :upload_screenshots
  resources :attachment_files
  get 'images/:token',  to: 'responses#open_image', as: 'images'
  get 'links/:token',   to: 'responses#open_url',   as: 'links'
  post 'activate/:token',   to: 'responses#open_submit',   as: 'activate'

  get 'dashboard/index'

  devise_for :users, controllers: { registrations: "registrations" }
  resources :users, only: [:index]


  # as :user do
  #   get "/register", to: "registrations#new", as: "register"
  #   post "/register", to: "registrations#create", as: "register"
  # end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get '/recipient_groups/new_modal', to: 'recipient_groups#new_modal'
  resources :recipient_groups do
     member do
      get 'edit_modal'
    end
    get '/new_modal', to: 'recipients#new_modal'
    resources :recipients do

      member do
        get 'edit_modal'

      end
    end
  end
  
get '/send_profiles/new_modal', to: 'send_profiles#new_modal'
  resources :send_profiles do
    member do
      get 'show_modal'
      get 'edit_modal'
    end
  end

  resources :campaigns do
    member do
      #get 'start'
      post 'start'
      post 'stop'
    end
    resources :recipient_details, only: [:index, :show]
  end

  get '/email_templates/new_modal', to: 'email_templates#new_modal'
  resources :email_templates do
    member do
      get 'edit_modal'
      get 'copy'
    end
  end

  get '/site_pages/new_modal', to: 'site_pages#new_modal'
  resources :site_pages do
    member do
      get 'edit_modal'
      get 'copy'
    end
  end

  # resources :phisher, only: [:create]
  root 'dashboard#index'

end
