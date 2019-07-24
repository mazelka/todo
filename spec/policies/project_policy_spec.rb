require 'rails_helper'

describe ProjectPolicy do
  subject { described_class }

  let(:user) { create(:user) }
  let(:not_permitted_user) { create(:user) }
  let!(:project) { create(:project, user: user) }
  let!(:not_permitted_project) { create(:project, user: not_permitted_user) }

  permissions :update?, :show?, :destroy?, :create?, :index? do
    it 'denies user to interact with project of other user' do
      expect(subject).not_to permit(user, not_permitted_project)
    end

    it 'allows user tointeract with his projects' do
      expect(subject).to permit(user, project)
    end
  end

  context 'scope' do
    it 'contains only allowed projects' do
      expect(Pundit.policy_scope(user, Project.all)).to match_array([project])
    end
  end
end
