require 'rails_helper'

describe UserPolicy do
  subject { described_class }

  let(:user) { create :user }

  permissions :destroy? do
    it 'denies user to destroy other user' do
      expect(subject).not_to permit(user, (create :user))
    end

    it 'allows user to destroy himself' do
      expect(subject).to permit(user, user)
    end
  end
end
