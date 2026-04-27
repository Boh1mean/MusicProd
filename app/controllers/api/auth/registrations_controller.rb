module Api
  module Auth
    class RegistrationsController < DeviseTokenAuth::RegistrationsController
      respond_to :json

      # POST /api/auth
      def create
        super
      end

      protected

      def sign_up_params
        params.require(:user).permit(:email, :password, :password_confirmation, :name)
      end
    end
  end
end
