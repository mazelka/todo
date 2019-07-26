require 'swagger_helper'
include JsonResponseHelpers

RSpec.describe 'tasks', type: :request, capture_examples: true do
  let!(:user) { create :user }
  let!(:project) { create :project, user: user }
  let!(:task) { create :task, project: project }
  let!(:comment) { create :comment, task: task }
  let!(:other_comment) { create :comment }

  def token
    Knock::AuthToken.new(payload: { sub: user.id }).token
  end

  context 'destroy comment' do
    path '/api/v1/comments/{id}' do
      delete(summary: 'destroy comment') do
        tags 'comments'
        parameter 'Content-Type', in: :header, type: :string
        parameter 'Authorization', in: :header, type: :string
        parameter 'id', in: :path, type: :string
        let(:'Content-Type') { 'application/json' }
        response(204, description: 'successful') do
          let(:Authorization) { "Bearer #{token}" }
          let(:id) { comment.id }
          around do |example|
            comment
            other_comment
            expect { example.run }.to change(Comment, :count).from(2).to(1)
          end
        end
        response(403, description: 'Forbidden') do
          let(:Authorization) { "Bearer #{token}" }
          let(:id) { other_comment.id }
          it 'has error title' do
            expect(json_errors.first['title']).to eq('Forbidden')
          end
        end
        response(404, description: 'not found') do
          let(:Authorization) { "Bearer #{token}" }
          let(:id) { Comment.last.id + 1 }
          it 'has error title' do
            expect(json_errors.first['title']).to eq('Record not Found')
          end
        end
        response(401, description: 'unauthorized') do
          let(:id) { comment.id }
          it 'has error title' do
            expect(json_errors.first['title']).to eq('Token is invalid')
          end
        end
      end
    end
  end
end
