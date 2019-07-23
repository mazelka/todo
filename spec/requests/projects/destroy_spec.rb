require 'swagger_helper'

RSpec.describe 'projects', type: :request, capture_examples: true do
  let!(:user) { create :user }
  let!(:project) { create :project, user: user }
  let!(:not_allowed_user) { create :user }
  let!(:not_allowed_project) { create :project, user: not_allowed_user }

  def token
    Knock::AuthToken.new(payload: { sub: user.id }).token
  end

  context 'destroy project' do
    path '/api/v1/users/{user_id}/projects/{id}' do
      delete(summary: 'destroy project') do
        tags 'projects'
        parameter 'Content-Type', in: :header, type: :string
        parameter 'Authorization', in: :header, type: :string
        parameter 'user_id', in: :path, type: :string
        parameter 'id', in: :path, type: :string
        let(:'Content-Type') { 'application/json' }
        response(204, description: 'successful') do
          let(:Authorization) { "Bearer #{token}" }
          let(:user_id) { user.id }
          let(:id) { project.id }
        end
        response(403, description: 'forbidden') do
          let(:Authorization) { "Bearer #{token}" }
          let(:user_id) { not_allowed_user.id }
          let(:id) { project.id }
        end
        response(403, description: 'forbidden') do
          let(:Authorization) { "Bearer #{token}" }
          let(:user_id) { user.id }
          let(:id) { not_allowed_project.id }
        end
        response(401, description: 'unauthorized') do
          let(:user_id) { user.id }
          let(:id) { project.id }
        end
      end
    end
  end
end
