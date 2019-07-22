class Api::V1::ApplicationController < ApplicationController
  include Knock::Authenticable
  include Pundit

  before_action :authenticate_user

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private

  def user_not_authorized
    head :forbidden
  end
end
