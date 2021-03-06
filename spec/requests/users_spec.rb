require 'swagger_helper'
include JsonResponseHelpers

RSpec.describe 'users', type: :request, capture_examples: true do
  let(:user) { create :user }
  let(:not_allowed_user) { create :user }
  let(:new_user) { build :user }

  def token
    Knock::AuthToken.new(payload: { sub: user.id }).token
  end

  path '/api/v1/users' do
    post(summary: 'create user') do
      tags 'users'
      parameter 'Content-Type', in: :header, type: :string
      let(:'Content-Type') { 'application/json' }
      parameter 'body', in: :body, required: true, schema: { '$ref' => '#/definitions/user' }
      response(201, description: 'successful') do
        let(:user) { build(:user) }
        let(:body) do
          { data: {
            attributes: {
              email: new_user.email,
              password: new_user.password,
              username: new_user.username
            }
          } }
        end
        around do |example|
          expect { example.run }.to change(User, :count).from(0).to(1)
        end
        it 'has valid response schema' do
          expect(response).to match_response_schema('user')
        end
        it 'has valid attributes' do
          expect(json_attributes['email']).to eq(new_user.email)
          expect(json_attributes['username']).to eq(new_user.username)
        end
      end
      response(422, description: 'unprocessable entity') do
        let(:user) { build(:user) }
        let(:body) do
          { data: {
            attributes: {
              email: '',
              password: new_user.password,
              username: new_user.username
            }
          } }
        end
      end
    end
  end

  path '/api/v1/users/{id}' do
    parameter 'id', in: :path, type: :string
    parameter 'Authorization', in: :header, type: :string

    delete(summary: 'delete user') do
      tags 'users'
      response(204, description: 'successful') do
        let(:'Authorization') { "Bearer #{token}" }
        let(:id) { user.id }
        around do |example|
          user
          expect { example.run }.to change(User, :count).from(1).to(0)
        end
      end

      response(401, description: 'unauthorized') do
        let(:id) { user.id }
        it 'has error title' do
          expect(json_errors.first['title']).to eq('Token is invalid')
        end
      end

      response(403, description: 'forbidden') do
        let(:'Authorization') { "Bearer #{token}" }
        let(:id) { not_allowed_user.id }
        it 'has error title' do
          expect(json_errors.first['title']).to eq('Forbidden')
        end
      end
    end
  end
end
