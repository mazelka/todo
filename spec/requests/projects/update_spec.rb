require 'swagger_helper'
include JsonResponseHelpers

RSpec.describe 'update project', type: :request, capture_examples: true do
  let!(:user) { create :user }
  let!(:project) { create :project, user: user }
  let!(:not_allowed_user) { create :user }
  let!(:not_allowed_project) { create :project, user: not_allowed_user }

  def token
    Knock::AuthToken.new(payload: { sub: user.id }).token
  end

  path '/api/v1/projects/{id}' do
    put(summary: 'update project') do
      tags 'projects'
      parameter 'Content-Type', in: :header, type: :string
      parameter 'Authorization', in: :header, type: :string
      parameter 'user_id', in: :path, type: :string
      parameter 'id', in: :path, type: :string
      parameter 'body', in: :body, required: true, schema: { '$ref' => '#/definitions/project' }
      let(:'Content-Type') { 'application/json' }
      response(200, description: 'successful') do
        let(:Authorization) { "Bearer #{token}" }
        let(:user_id) { user.id }
        let(:id) { project.id }
        let(:body) do
          { data: {
            attributes: {
              name: 'updated name'
            }
          } }
        end
        it 'has valid response schema' do
          expect(response).to match_response_schema('project')
        end
        it 'has updated name' do
          expect(json_attributes['name']).to eq('updated name')
        end
      end

      response(422, description: 'unprocessable entity') do
        let(:Authorization) { "Bearer #{token}" }
        let(:user_id) { user.id }
        let(:id) { project.id }
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
        let(:user_id) { user.id }
        let(:id) { not_allowed_project.id }
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
      response(401, description: 'unauthorized') do
        let(:user_id) { user.id }
        let(:id) { project.id }
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
