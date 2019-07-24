require 'rails_helper'

describe TaskPolicy do
  subject { described_class }

  let(:user) { create(:user) }
  let(:not_permitted_project) { create(:project) }
  let!(:project) { create(:project, user: user) }
  let!(:task) { create(:task, project: project) }
  let!(:not_permitted_task) { create(:task, project: not_permitted_project) }

  permissions :update?, :show?, :destroy? do
    it 'denies user to interact with project of other user' do
      expect(subject).not_to permit(user, not_permitted_task)
    end

    it 'allows user to interact with his projects' do
      expect(subject).to permit(user, task)
    end
  end

  context 'scope' do
    it 'contains only allowed projects' do
      expect(Pundit.policy_scope(user, Task.all.where(project: project))).to match_array([task])
    end
  end
end
