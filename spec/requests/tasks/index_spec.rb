require 'swagger_helper'
include JsonResponseHelpers

RSpec.describe 'tasks', type: :request, capture_examples: true do
  let!(:user) { create :user }
  let!(:project) { create :project, user: user }
  let!(:task) { create_list :task, 2, project: project }
  let!(:not_allowed_project) { create :project }

  def token
    Knock::AuthToken.new(payload: { sub: user.id }).token
  end

  context 'get project tasks' do
    path '/api/v1/projects/{project_id}/tasks' do
      get(summary: 'get project tasks') do
        tags 'tasks'
        parameter 'Content-Type', in: :header, type: :string
        parameter 'Authorization', in: :header, type: :string
        parameter 'project_id', in: :path, type: :string
        let(:'Content-Type') { 'application/json' }
        response(200, description: 'successful') do
          let(:Authorization) { "Bearer #{token}" }
          let(:project_id) { project.id }
          it 'has valid response schema' do
            expect(response).to match_response_schema('tasks')
          end
        end
        response(401, description: 'unauthorized') do
          let(:project_id) { project.id }
          it 'has error title' do
            expect(json_errors.first['title']).to eq('Token is invalid')
          end
        end
        response(404, description: 'forbidden') do
          let(:Authorization) { "Bearer #{token}" }
          let(:project_id) { not_allowed_project.id }
          it 'has error title' do
            expect(json_errors.first['title']).to eq('Record not Found')
          end
        end
      end
    end
  end
end
