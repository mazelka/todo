class Api::V1::CommentsController < Api::V1::ApplicationController
  before_action :find_comment, only: :destroy
  before_action :find_task, only: [:index, :create]

  def index
    @comments = policy_scope(Comment).where(task: @task)
    render json: CommentSerializer.new(@comments), adapter: :json_api
  end

  def create
    @comment = Comment.new(comment_params.merge(task: @task))
    if @comment.save
      render json: CommentSerializer.new(@comment), adapter: :json_api, status: :created
    else
      render json: ErrorSerializer.new(@comment).response, adapter: :json_api,
             status: :unprocessable_entity
    end
  end

  def destroy
    @comment.destroy
    head :no_content
  end

  private

  def find_task
    @task = Task.find(params[:task_id])
    authorize @task
  end

  def find_comment
    @comment = Comment.find(params[:id])
    authorize @comment
  end

  def comment_params
    params.require(:data).require(:attributes).permit(:text, :attachment)
  end

  def attachment_params
    params.require(:data).require(:attributes).permit(:attachment)
  end
end
