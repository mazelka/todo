class UserTokenController < Knock::AuthTokenController
  skip_before_action :verify_authenticity_token

  def auth_params
    params.require(:data).require(:attributes).permit(:email, :username, :password)
    # || params.require(:data).require(:attributes).permit(:password, :username)
  end
end
