Rails.application.routes.draw do
  namespace :api do
    mount_devise_token_auth_for "User", at: "auth", controllers: {
      registrations: "api/auth/registrations",
      sessions: "api/auth/sessions"
    }

    namespace :aws do
      resources :tracks, only: [ :index ] do
        member do
          post :like_track # POST /api/aws/tracks/:id/like
        end
        collection do
          post :sync   # POST /api/tracks/sync
          get :top_tracks # GET /api/tracks/top_tracks
          get :liked # GET /api/aws/tracks/liked
        end
      end
      resources :playlists, only: [ :create, :index, :show ] do
        collection do
          post :fetch_from_yandex_cloud # POST
          get :playlists # GET
        end
      end
    end
  end
end
