module Api
    module Auth
      class SessionsController < DeviseTokenAuth::SessionsController
        respond_to :json

        # POST /api/v1/auth/sign_in
        def create
          super
        end

        # POST /api/v1/auth/sign_out
        def destroy
          super
        end
      end
    end
end
