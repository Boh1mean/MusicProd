module Api
  module Auth
    class RegistrationsController < DeviseTokenAuth::RegistrationsController
      before_action :configure_permitted_parameters, if: :devise_controller?
        respond_to :json

        # POST /api/auth
        def create
          super
        end

        protected

        def configure_permitted_parameters
          devise_parameter_sanitizer.permit(:sign_up, keys: [ :name ])
        end

        def sign_up_params
          params.require(:user).permit(:email, :password, :password_confirmation, :name)
        end
    end
  end
end
