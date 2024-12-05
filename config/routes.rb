Rails.application.routes.draw do
  namespace :api do
    mount_devise_token_auth_for "User", at: "auth", controllers: {
      registrations: "api/auth/registrations",
      sessions: "api/auth/sessions"
    }

    namespace :aws do
      resources :tracks, only: [ :index ] do
        collection do
          post :sync   # POST /api/tracks/sync
        end
      end
    end
  end
end
