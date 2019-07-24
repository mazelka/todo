require 'swagger_helper'
include JsonResponseHelpers

RSpec.describe 'projects', type: :request, capture_examples: true do
  let!(:user) { create :user }
  let!(:project) { build :project, user: user }

  def token
    Knock::AuthToken.new(payload: { sub: user.id }).token
  end

  path '/api/v1/projects/' do
    post(summary: 'create new project') do
      tags 'projects'
      parameter 'Content-Type', in: :header, type: :string
      parameter 'user_id', in: :path, type: :string
      parameter 'Authorization', in: :header, type: :string
      parameter 'body', in: :body, required: true, schema: { '$ref' => '#/definitions/project' }
      let(:'Content-Type') { 'application/json' }
      response(201, description: 'successful') do
        start_project_count = Project.count
        let(:Authorization) { "Bearer #{token}" }
        let(:user_id) { user.id }
        let(:body) do
          { data: {
            attributes: {
              name: project.name
            }
          } }
        end
        it 'has valid response schema' do
          expect(response).to match_response_schema('project')
        end
        it 'has valid name' do
          expect(json_attributes['name']).to eq(project.name)
        end
        it '1 project created' do
          expect(Project.count).to eq(start_project_count + 1)
        end
      end
      response(422, description: 'unprocessable entity') do
        let(:Authorization) { "Bearer #{token}" }
        let(:user_id) { user.id }
        let(:body) do
          { data: {
            attributes: {
              name: ''
            }
          } }
        end
      end
      response(401, description: 'unauthorized') do
        let(:user_id) { user.id }
        let(:body) do
          { data: {
            attributes: {
              name: 'test'
            }
          } }
        end
        it 'has error title' do
          expect(json_errors.first['title']).to eq('Token is invalid')
        end
      end
    end
  end
end
