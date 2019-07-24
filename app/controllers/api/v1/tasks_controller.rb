class Api::V1::TasksController < Api::V1::ApplicationController
  before_action :find_task, only: [:show, :update, :destroy]
  before_action :find_task_to_move, only: [:move_lower, :move_higher]
  before_action :find_project, only: [:index, :create]

  def index
    @tasks = policy_scope(Task).where(project: @project)
    render json: TaskSerializer.new(@tasks), adapter: :json_api
  end

  def show
    render json: TaskSerializer.new(@task)
  end

  def create
    @task = Task.new(task_params.merge(project: @project))
    if @task.save
      render json: TaskSerializer.new(@task), adapter: :json_api, status: :created
    else
      render json: ErrorSerializer.new(@task).response, adapter: :json_api,
             status: :unprocessable_entity
    end
  end

  def update
    if @task.update(task_params)
      render json: TaskSerializer.new(@task), adapter: :json_api
    else
      render json: ErrorSerializer.new(@task).response, adapter: :json_api,
             status: :unprocessable_entity
    end
  end

  def move_lower
    @task.move_lower
    render json: TaskSerializer.new(@task), adapter: :json_api
  end

  def move_higher
    @task.move_higher
    render json: TaskSerializer.new(@task), adapter: :json_api
  end

  def destroy
    @task.destroy
    head :no_content
  end

  private

  def find_task
    @task = Task.find(params[:id])
    authorize @task
  end

  def find_task_to_move
    @task = Task.find(params[:task_id])
    authorize @task, :update?
  end

  def find_project
    @project = current_user.projects.find(params[:project_id])
    authorize @project, policy_class: ProjectPolicy
  end

  def task_params
    params.require(:data).require(:attributes).permit(:name, :deadline, :position, :done)
  end
end
