class Api::V1::UsersController < Api::V1::ApplicationController
  before_action :authenticate_user, only: [:destroy, :index]

  def create
    user = User.new(user_params)
    if user.save
      render json: UserSerializer.new(user), adapter: :json_api, status: :created
    else
      render json: ErrorSerializer.new(user).response, adapter: :json_api,
             status: :unprocessable_entity
    end
  end

  def destroy
    @user = User.find(params[:id])
    authorize @user
    if @user.destroy
      head :no_content
    else
      render json: ErrorSerializer.new(user).response, adapter: :json_api,
             status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:data).require(:attributes).permit(:username, :email, :password)
  end
end
