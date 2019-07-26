class ErrorSerializer
  def initialize(model)
    @model = model
  end

  def self.user_not_authorized
    {
      title: 'Forbidden',
      status: 403,
      source: { 'pointer' => '/headers/authorization' },
      detail: 'You are not authorized.'
    }
  end

  def self.not_found_error
    {
      title: 'Record not Found',
      status: 404,
      source: { pointer: '/request/url/:id' },
      detail: 'We could not find the object you were looking for.'
    }
  end

  def self.authorization_error
    {
      title: 'Token is invalid',
      status: 401,
      source: { 'pointer' => '/headers/authorization' },
      detail: 'You must provide valid email and password in order to exchange it for token.'
    }
  end

  def response
    { errors: serialized_json }
  end

  def serialized_json
    errors = @model.errors.messages.map do |field, errors|
      errors.map do |error_message|
        {
          source: { pointer: "/data/attributes/#{field}" },
          detail: error_message
        }
      end
    end
    errors.flatten
  end
end
