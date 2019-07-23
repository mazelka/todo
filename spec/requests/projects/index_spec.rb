require 'swagger_helper'
include JsonResponseHelpers

RSpec.describe 'projects', type: :request, capture_examples: true do
  let!(:user) { create :user }
  let!(:project) { create :project, user: user }
  let!(:project2) { create :project, user: user }
  let!(:not_allowed_user) { create :user }
  let!(:not_allowed_project) { create :project, user: not_allowed_user }

  def token
    Knock::AuthToken.new(payload: { sub: user.id }).token
  end

  context 'get user projects' do
    path '/api/v1/users/{user_id}/projects/' do
      get(summary: 'get user projects') do
        tags 'projects'
        parameter 'Content-Type', in: :header, type: :string
        parameter 'Authorization', in: :header, type: :string
        parameter 'user_id', in: :path, type: :string
        let(:'Content-Type') { 'application/json' }
        response(200, description: 'successful') do
          let(:Authorization) { "Bearer #{token}" }
          let(:user_id) { user.id }
          it 'has valid response schema' do
            expect(response).to match_response_schema('projects')
          end
        end
        response(401, description: 'unauthorized') do
          let(:user_id) { user.id }
        end
        response(403, description: 'forbidden') do
          let(:Authorization) { "Bearer #{token}" }
          let(:user_id) { not_allowed_user.id }
          it 'has error title' do
            expect(json_errors.first['title']).to eq('Unauthorized')
          end
        end
      end
    end
  end
end
