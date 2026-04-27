class ApplicationController < ActionController::API
  include DeviseTokenAuth::Concerns::SetUserByToken
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def authenticate_user!
    uid    = request.headers["uid"]
    token  = request.headers["access-token"]
    client = request.headers["client"] || "default"

    user = User.find_by(uid: uid) if uid.present?

    if user && user.valid_token?(token, client)
      @resource = user
    else
      render json: { errors: [ "Authorized users only." ] }, status: :unauthorized
    end
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [ :name ])
  end
end
