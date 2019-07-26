require 'swagger_helper'

RSpec.describe 'tasks', type: :request, capture_examples: true do
  let!(:user) { create :user }
  let!(:project) { create :project, user: user }
  let!(:task) { create :task, project: project }
  let!(:other_task) { create :task }

  def token
    Knock::AuthToken.new(payload: { sub: user.id }).token
  end

  context 'destroy task' do
    path '/api/v1/tasks/{id}' do
      delete(summary: 'destroy task') do
        tags 'tasks'
        parameter 'Content-Type', in: :header, type: :string
        parameter 'Authorization', in: :header, type: :string
        parameter 'id', in: :path, type: :string
        let(:'Content-Type') { 'application/json' }
        response(204, description: 'successful') do
          let(:Authorization) { "Bearer #{token}" }
          let(:id) { task.id }
          around do |example|
            task
            other_task
            expect { example.run }.to change(Task, :count).from(2).to(1)
          end
        end
        response(403, description: 'Forbidden') do
          let(:Authorization) { "Bearer #{token}" }
          let(:id) { other_task.id }
          it 'has error title' do
            expect(json_errors.first['title']).to eq('Forbidden')
          end
        end
        response(404, description: 'not found') do
          let(:Authorization) { "Bearer #{token}" }
          let(:id) { Task.last.id + 1 }
          it 'has error title' do
            expect(json_errors.first['title']).to eq('Record not Found')
          end
        end
        response(401, description: 'unauthorized') do
          let(:id) { other_task.id }
          it 'has error title' do
            expect(json_errors.first['title']).to eq('Token is invalid')
          end
        end
      end
    end
  end
end
