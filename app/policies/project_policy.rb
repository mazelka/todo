class ProjectPolicy < ApplicationPolicy
  attr_reader :user, :project

  def initialize(user, project)
    @user = user
    @project = project
  end

  def update?
    project.user_id == user.id
  end

  def show?
    project.user_id == user.id
  end

  def destroy?
    project.user_id == user.id
  end

  class Scope < Scope
    def resolve
      scope.where(user_id: user.id)
    end
  end
end
