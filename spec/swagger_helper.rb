require 'rspec/rails/swagger'
require 'rails_helper'

RSpec.configure do |config|
  # Specify a root directory where the generated Swagger files will be saved.
  config.swagger_root = Rails.root.to_s + '/public'

  # Define one or more Swagger documents and global metadata for each.
  config.swagger_docs = {
    'swagger/v1/swagger.json' => {
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
          properties: {
            data: {
              type: 'object',
              properties: {
                attributes: {
                  type: 'object',
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
        user: {
          type: 'object',
          properties: {
            data: {
              type: 'object',
              properties: {
                attributes: {
                  type: 'object',
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
