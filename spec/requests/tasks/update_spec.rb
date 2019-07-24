require 'swagger_helper'
include JsonResponseHelpers

RSpec.describe 'update task', type: :request, capture_examples: true do
  let!(:user) { create :user }
  let!(:project) { create :project, user: user }
  let!(:task) { create :task, project: project }
  let!(:new_task) { build :task, project: project, deadline: '2020-10-10' }
  let!(:not_allowed_task) { create :task }

  def token
    Knock::AuthToken.new(payload: { sub: user.id }).token
  end

  path '/api/v1/tasks/{id}' do
    put(summary: 'update task') do
      tags 'tasks'
      parameter 'Content-Type', in: :header, type: :string
      parameter 'Authorization', in: :header, type: :string
      parameter 'id', in: :path, type: :string
      parameter 'body', in: :body, required: true, schema: { '$ref' => '#/definitions/task' }
      let(:'Content-Type') { 'application/json' }
      response(200, description: 'successful') do
        let(:Authorization) { "Bearer #{token}" }
        let(:id) { task.id }
        let(:body) do
          { data: {
            attributes: {
              name: new_task.name,
              deadline: new_task.deadline,
              done: true
            }
          } }
        end
        it 'has valid response schema' do
          expect(response).to match_response_schema('task')
        end
        it 'has updated attributes' do
          expect(json_attributes['name']).to eq(new_task.name)
          expect(json_attributes['deadline']).to eq(new_task.deadline.to_s[0..9])
          expect(json_attributes['done']).to be true
        end
      end
      response(422, description: 'unprocessable entity') do
        let(:Authorization) { "Bearer #{token}" }
        let(:id) { task.id }
        let(:body) do
          { data: {
            attributes: {
              name: ''
            }
          } }
        end
      end
      response(404, description: 'not found') do
        let(:Authorization) { "Bearer #{token}" }
        let(:id) { Task.last.id + 1 }
        let(:body) do
          { data: {
            attributes: {
              name: 'updated name'
            }
          } }
        end
        it 'has error title' do
          expect(json_errors.first['title']).to eq('Record not Found')
        end
      end
      response(403, description: 'forbidden') do
        let(:Authorization) { "Bearer #{token}" }
        let(:id) { not_allowed_task.id }
        let(:body) do
          { data: {
            attributes: {
              name: 'updated name'
            }
          } }
        end
        it 'has error title' do
          expect(json_errors.first['title']).to eq('Forbidden')
        end
      end
      response(401, description: 'unauthorized') do
        let(:id) { task.id }
        let(:body) do
          { data: {
            attributes: {
              name: 'updated name'
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
