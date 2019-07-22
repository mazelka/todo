require 'swagger_helper'

RSpec.describe 'user tokens', type: :request, capture_examples: true do
  let(:user) { create :user }

  path '/api/v1/user_token' do
    post(summary: 'login with email or username') do
      tags 'authorize'
      parameter 'Content-Type', { in: :header, type: :string }
      let(:'Content-Type') { 'application/json' }
      parameter 'body', { in: :body, required: true, schema: {
                  '$ref' => '#/user.json',
                } }
      response(201, description: 'successful login with email') do
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
      response(201, description: 'successful login with username') do
        let(:user) { create(:user) }
        let(:body) do
          { data: {
            attributes: {
              username: user.username,
              password: user.password,
            },
          } }
        end
      end
      response(404, description: 'user not found') do
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
