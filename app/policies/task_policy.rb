class TaskPolicy < ApplicationPolicy
  attr_reader :user, :task

  def initialize(user, task)
    @user = user
    @task = task
  end

  def update?
    task.project.user == user
  end

  def show?
    task.project.user == user
  end

  def move_lower?
    task.project.user == user
  end

  def move_higher?
    task.project.user == user
  end

  def destroy?
    task.project.user == user
  end
end
