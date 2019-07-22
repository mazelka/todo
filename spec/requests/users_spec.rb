require 'swagger_helper'

RSpec.describe 'users', type: :request, capture_examples: true do
  let(:user) { create :user }
  let(:new_user) { create :user }

  def token
    Knock::AuthToken.new(payload: { sub: user.id }).token
  end

  path '/api/v1/users' do
    post(summary: 'create user') do
      tags 'users'
      parameter 'Content-Type', { in: :header, type: :string }
      let(:'Content-Type') { 'application/json' }
      parameter 'body', { in: :body, required: true, schema: {
        '$ref' => '#/user.json',
      } }
      response(200, description: 'successful') do
        let(:user) { build(:user) }
        let(:body) do
          { data: {
            attributes: {
              email: user.email,
              password: user.password,
              username: user.username,
            },
          } }
        end
      end
      response(422, description: 'unprocessable entity') do
        let(:user) { build(:user) }
        let(:body) do
          { data: {
            attributes: {
              email: '',
              password: user.password,
              username: user.username,
            },
          } }
        end
      end
    end
  end

  path '/api/v1/users/{id}' do
    parameter 'id', { in: :path, type: :string }
    parameter 'Authorization', { in: :header, type: :string }

    delete(summary: 'delete user') do
      tags 'users'
      response(204, description: 'successful') do
        let(:'Authorization') { "Bearer #{token}" }
        let(:id) { user.id }
      end

      response(401, description: 'unauthorized') do
        let(:id) { user.id }
      end

      response(403, description: 'forbidden') do
        let(:'Authorization') { "Bearer #{token}" }
        let(:id) { new_user.id }
      end
    end
  end
end
