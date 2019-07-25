require 'swagger_helper'
include JsonResponseHelpers
include AttachmentUrlHelper

RSpec.describe 'comments', type: :request, capture_examples: true do
  let!(:user) { create :user }
  let!(:project) { create :project, user: user }
  let!(:task) { create :task, project: project }
  let!(:not_allowed_task) { create :task }
  let!(:comment) { build :comment, :with_jpg_attachment, task: task }

  def token
    Knock::AuthToken.new(payload: { sub: user.id }).token
  end

  path '/api/v1/tasks/{task_id}/comments' do
    post(summary: 'create new comment') do
      tags 'comments'
      parameter 'Content-Type', in: :header, type: :string
      parameter 'task_id', in: :path, type: :string
      parameter 'Authorization', in: :header, type: :string
      parameter 'body', in: :body, type: :formData, schema: { '$ref' => '#/definitions/comment' }
      let(:'Content-Type') { 'application/json' }
      response(201, description: 'successful') do
        let(:task_id) { task.id }
        let(:Authorization) { "Bearer #{token}" }
        let(:body) do
          { data: {
            attributes: {
              text: comment.text,
              attachment: blob_for('photo.jpg').signed_id
            }
          } }
        end
        around do |example|
          expect { example.run }.to change(Comment, :count).by(1)
          expect { example.run }.to change(ActiveStorage::Attachment, :count).by(1)
        end
        it 'has valid response schema' do
          expect(response).to match_response_schema('comment')
        end
        it 'has valid text' do
          expect(json_attributes['text']).to eq(comment.text)
        end
      end
      response(201, description: 'successful without attachment') do
        let(:Authorization) { "Bearer #{token}" }
        let(:task_id) { task.id }
        let(:body) do
          { data: {
            attributes: {
              text: comment.text
            }
          } }
        end
      end
      response(422, description: 'unprocessable entity') do
        let(:Authorization) { "Bearer #{token}" }
        let(:task_id) { task.id }
        let(:body) do
          { data: {
            attributes: {
              text: 'a'
            }
          } }
        end
      end
      response(422, description: 'unprocessable entity') do
        let(:Authorization) { "Bearer #{token}" }
        let(:task_id) { task.id }
        let(:body) do
          { data: {
            attributes: {
              text: comment.text,
              attachment: blob_for('18-CTFL-130229-06.pdf').signed_id
            }
          } }
        end
      end
      response(403, description: 'Forbidden') do
        let(:Authorization) { "Bearer #{token}" }
        let(:task_id) { not_allowed_task.id }
        let(:body) do
          { data: {
            attributes: {
              text: comment.text
            }
          } }
        end
        it 'has error title' do
          expect(json_errors.first['title']).to eq('Forbidden')
        end
      end
      response(401, description: 'unauthorized') do
        let(:task_id) { task.id }
        let(:body) do
          { data: {
            attributes: {
              text: comment.text
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
