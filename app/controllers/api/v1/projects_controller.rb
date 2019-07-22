class Api::V1::ProjectsController < Api::V1::ApplicationController
  before_action :authenticate_user
  before_action :find_project, only: [:show, :update, :destroy]

  def index
    @projects = current_user.projects
    render json: @projects, adapter: :json_api
  end

  def show
    render json: @project
  end

  def create
    @project = Project.new(project_params)
    if @project.save
      render json: @project, adapter: :json_api
    else
      render json: @project, adapter: :json_api,
             serializer: ErrorSerializer,
             status: :unprocessable_entity
    end
  end

  def update
    if @project.update(project_params)
      render json: @project, adapter: :json_api
    else
      render json: @project, adapter: :json_api,
             serializer: ErrorSerializer,
             status: :unprocessable_entity
    end
  end

  def destroy
    @project.destroy
    render json: { status: 200, msg: 'Deleted' }, adapter: :json_api
  end

  private

  def find_project
    authorize Project.find(params[:id])
    @project = current_user.projects.find(params[:id])
  end

  def project_params
    params.require(:data).require(:attributes).permit(:name).merge(user: current_user)
  end
end
