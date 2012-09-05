Claw::Application.routes.draw do

  # USERS
  devise_for :users
  resources :users, :only => :index
  # show action at the end

  # BANDS
  resources :bands
  get ":user_id/bands", :controller => :bands, :action => :index, :as => :user_bands

  # FRIENDS
  resources :friends, :only => [:index, :show, :destroy]
  post "add_friend", :to => "friends#add_friend"

  # REQUESTS
  resources :requests, :only => [:destroy]
  put "requests/:id/accept" => "requests#accept", :as => :accept_request
  get "requests/:type" => "requests#index", :as => :requests
  
  # SONGS
  resources :songs do
    resources :comments
    get "song_versions/new" => "song_versions#new", :as => :new_version
  end
  post "songs/:id/share" => "songs#share", :as => :share_song
  
  # SONG VERSIONS
  resources :song_versions, :except => [:update] do
    resources :tracks, :except => [:edit, :new, :update]
    put "tracks/:id/set_name" => "tracks#set_name"

    resources :clips, :except => [:edit, :new, :update]
    put "clips/:id/offset_source" => "clips#offset_source"
    put "clips/:id/offset_begin"  => "clips#offset_begin"
    put "clips/:id/offset_end"    => "clips#offset_end"

    resources :audio_sources, :except => [:edit, :update]

    resource :root_action, :only => [:update, :show], :controller => "actions"

  end
  put  "song_versions/:id/set_title" => "song_versions#set_title"
  post "song_versions/:id/undo"      => "song_versions#undo"
  post "song_versions/:id/redo"      => "song_versions#redo"
  post "song_versions/:id/share"     => "song_versions#share", :as => :share_song_version
  
  # at last to make it work
  get ":id" => "users#show", :as => :show_user

  root :to => "users#index"

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
