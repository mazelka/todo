require 'swagger_helper'

RSpec.describe 'user tokens', type: :request, capture_examples: true do
  let(:user) { create :user }

  path '/user_token' do
    post(summary: 'create user') do
      tags 'authorize'
      parameter 'Content-Type', { in: :header, type: :string }
      let(:'Content-Type') { 'application/json' }
      parameter 'body', { in: :body, required: true, schema: {
        type: :object,
        properties: {
          data: {
            type: :object,
            properties: {
              attributes: {
                type: :object,
                properties: {
                  email: { type: :string },
                  password: { type: :string },
                },
              },
            },
          },
        },
      } }
      response(201, description: 'successful') do
        let(:user) { create(:user) }
        let(:body) do
          { data: {
            attributes: {
              email: user.email,
              password: user.password,
            },
          } }
        end
      end
      response(404, description: 'not found') do
        let(:user) { create(:user) }
        let(:body) do
          { data: {
            attributes: {
              email: user.email,
              password: '',
            },
          } }
        end
      end
    end
  end
end
