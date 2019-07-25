require 'swagger_helper'
include JsonResponseHelpers

RSpec.describe 'tasks', type: :request, capture_examples: true do
  let!(:user) { create :user }
  let!(:project) { create :project, user: user }
  let!(:task) { build :task, project: project }

  def token
    Knock::AuthToken.new(payload: { sub: user.id }).token
  end

  path '/api/v1/projects/{project_id}/tasks' do
    post(summary: 'create new task') do
      tags 'tasks'
      parameter 'Content-Type', in: :header, type: :string
      parameter 'project_id', in: :path, type: :string
      parameter 'Authorization', in: :header, type: :string
      parameter 'body', in: :body, required: true, schema: { '$ref' => '#/definitions/task' }
      let(:'Content-Type') { 'application/json' }
      response(201, description: 'successful') do
        let(:Authorization) { "Bearer #{token}" }
        let(:project_id) { project.id }
        let(:body) do
          { data: {
            attributes: {
              name: task.name,
              deadline: task.deadline,
              done: false,
              priority: nil
            }
          } }
        end
        around do |example|
          expect { example.run }.to change(Task, :count).by(1)
        end
        it 'has valid response schema' do
          expect(response).to match_response_schema('task')
        end
        it 'has valid name' do
          expect(json_attributes['name']).to eq(task.name)
        end
      end
      response(422, description: 'unprocessable entity') do
        let(:Authorization) { "Bearer #{token}" }
        let(:project_id) { project.id }
        let(:body) do
          { data: {
            attributes: {
              name: ''
            }
          } }
        end
      end
      response(401, description: 'unauthorized') do
        let(:project_id) { project.id }
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
