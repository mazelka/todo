require 'rails_helper'

describe CommentPolicy do
  subject { described_class }

  let(:user) { create :user }
  let(:not_allowed_user) { create :user }
  let(:project) { create :project, user: user }
  let(:task) { create :task, project: project }
  let(:comment) { create :comment, task: task }

  permissions :destroy? do
    it 'denies other user to destroy comment of user' do
      expect(subject).not_to permit(not_allowed_user, comment)
    end

    it 'allows user to destroy his comment' do
      expect(subject).to permit(user, comment)
    end
  end
end
