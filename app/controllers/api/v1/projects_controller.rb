class Api::V1::ProjectsController < Api::V1::ApplicationController
  before_action :find_project, only: [:show, :update, :destroy]

  def index
    @projects = current_user.projects
    render json: ProjectSerializer.new(@projects), adapter: :json_api
  end

  def show
    render json: ProjectSerializer.new(@project)
  end

  def create
    @project = Project.new(project_params)
    if @project.save
      render json: ProjectSerializer.new(@project), adapter: :json_api, status: :created
    else
      render json: ErrorSerializer.new(@project).response, adapter: :json_api,
             status: :unprocessable_entity
    end
  end

  def update
    if @project.update(project_params)
      render json: ProjectSerializer.new(@project), adapter: :json_api
    else
      render json: ErrorSerializer.new(@project).response, adapter: :json_api,
             status: :unprocessable_entity
    end
  end

  def destroy
    @project.destroy
    head :no_content
  end

  private

  def find_project
    @project = current_user.projects.find(params[:id])
    authorize @project
  end

  def project_params
    params.require(:data).require(:attributes).permit(:name).merge(user: current_user)
  end
end
