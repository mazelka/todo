class UserTokenController < Knock::AuthTokenController
  skip_before_action :verify_authenticity_token

  def auth_params
    params.require(:data).require(:attributes).permit(:email, :password, :username)
  end
end
