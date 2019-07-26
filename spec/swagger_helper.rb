require 'rspec/rails/swagger'
require 'rails_helper'

RSpec.configure do |config|
  include ActionDispatch::TestProcess
  # Specify a root directory where the generated Swagger files will be saved.
  config.swagger_root = Rails.root.to_s + '/public'

  # Define one or more Swagger documents and global metadata for each.
  config.swagger_docs = {
    'docs/swagger/v1/swagger.json' => {
      swagger: '2.0',
      info: {
        title: 'Todo',
        version: 'v1',
        description: 'This is the first version API'
      },
      definitions: {
        project: {
          type: 'object',
          properties: {
            data: {
              type: 'object',
              properties: {
                attributes: {
                  type: 'object',
                  required: %i[name],
                  properties: {
                    name: { type: 'string' }
                  }
                }
              }
            }
          }
        },
        task: {
          type: 'object',
          in: 'formData',
          properties: {
            data: {
              type: 'object',
              properties: {
                attributes: {
                  type: 'object',
                  required: %i[name],
                  properties: {
                    name: { type: 'string' },
                    deadline: { type: 'string' },
                    priority: { type: 'string' },
                    done: { type: 'boolean' }
                  }
                }
              }
            }
          }
        },
        comment: {
          consumes: ['multipart/form-data'],
          type: 'object',
          in: 'formData',
          properties: {
            data: {
              type: 'object',
              properties: {
                attributes: {
                  type: 'object',
                  required: %i[name],
                  properties: {
                    name: { type: 'string' },
                    attachment: { type: 'string' }
                  }
                }
              }
            }
          }
        },
        user: {
          type: 'object',
          properties: {
            data: {
              type: 'object',
              properties: {
                attributes: {
                  type: 'object',
                  required: %i[email username password],
                  properties: {
                    email: { type: 'string' },
                    username: { type: 'string' },
                    password: { type: 'string' }
                  }
                }
              }
            }
          }
        }
      }
    }
  }
end
