require 'swagger_helper'
include JsonResponseHelpers

RSpec.describe 'projects', type: :request, capture_examples: true do
  let!(:user) { create :user }
  let!(:project) { create :project, user: user }
  let!(:not_allowed_user) { create :user }
  let!(:not_allowed_project) { create :project, user: not_allowed_user }

  def token
    Knock::AuthToken.new(payload: { sub: user.id }).token
  end

  context 'show user project' do
    path '/api/v1/projects/{id}' do
      get(summary: 'show user project') do
        tags 'projects'
        parameter 'Content-Type', in: :header, type: :string
        parameter 'Authorization', in: :header, type: :string
        parameter 'id', in: :path, type: :string
        let(:'Content-Type') { 'application/json' }
        response(200, description: 'successful') do
          let(:Authorization) { "Bearer #{token}" }
          let(:id) { project.id }
          it 'has valid response schema' do
            expect(response).to match_response_schema('project')
          end
        end
        response(404, description: 'not found') do
          let(:Authorization) { "Bearer #{token}" }
          let(:id) { not_allowed_project.id }
          it 'has error title' do
            expect(json_errors.first['title']).to eq('Record not Found')
          end
        end
        response(401, description: 'unauthorized') do
          let(:id) { project.id }
          it 'has error title' do
            expect(json_errors.first['title']).to eq('Token is invalid')
          end
        end
      end
    end
  end
end
