class Api::V1::ApplicationController < ApplicationController
  class AuthorizationError < StandardError; end

  include Knock::Authenticable
  include Pundit

  before_action :authenticate_user

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized_error
  rescue_from ActiveRecord::RecordNotFound, with: :not_found_error
  rescue_from AuthorizationError, with: :unauthorized_entity

  def user_not_authorized_error
    error = ErrorSerializer.user_not_authorized
    render json: { "errors": [error] }, status: :forbidden
  end

  def not_found_error
    error = ErrorSerializer.not_found_error
    render json: { "errors": [error] }, status: :not_found
  end

  def unauthorized_entity(_)
    error = ErrorSerializer.authorization_error
    render json: { "errors": [error] }, status: :unauthorized
  end
end
