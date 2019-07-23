class UserPolicy
  attr_reader :object_user, :user

  def initialize(user, object_user)
    @user = user
    @object_user = object_user
  end

  def index?
    object_user == user
  end

  def create?
    object_user == user
  end

  def show?
    object_user == user
  end

  def update?
    object_user == user
  end

  def destroy?
    object_user == user
  end
end
