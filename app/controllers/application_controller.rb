class ApplicationController < ActionController::API
  class AuthorizationError < StandardError; end

  include Knock::Authenticable
  include Pundit

  before_action :authenticate_user

  rescue_from Pundit::NotAuthorizedError, with: :authorization_error
  rescue_from ActiveRecord::RecordNotFound, with: :not_found_error
  rescue_from AuthorizationError, with: :authorization_error

  private

  def authorization_error
    error = {
      status: 403,
      source: { 'pointer' => '/headers/authorization' },
      title: 'Not authorized',
      detail: 'You have no right to access this resource.',
    }
    render json: { "errors": [error] }, status: 403
  end

  def not_found_error
    error = {
      title: 'Record not Found',
      status: 404,
      detail: 'We could not find the object you were looking for.',
      source: { pointer: '/request/url/:id' },
    }
    render json: { "errors": [error] }, status: 404
  end
end
