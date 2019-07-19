class UsersController < ApplicationController
  before_action :authenticate_user, only: [:destroy, :index]

  def index
    render json: { status: 200, msg: 'Logged-in' }, adapter: :json_api
  end

  def create
    user = User.new(user_params)
    if user.save
      render json: user, adapter: :json_api
    else
      render json: user, adapter: :json_api,
             serializer: ErrorSerializer,
             status: :unprocessable_entity
    end
  end

  def destroy
    @user = User.find(params[:id])
    authorize @user
    if @user.destroy
      render json: { status: 200, msg: 'Deleted' }, adapter: :json_api
    else
      render json: @user, adapter: :json_api,
             serializer: ErrorSerializer,
             status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:data).require(:attributes).permit(:username, :email, :password)
  end
end
