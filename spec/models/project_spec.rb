require 'rails_helper'

RSpec.describe Project, type: :model do
  context 'associations' do
    it { should belong_to(:user) }
    it { should have_many(:tasks) }
  end
  context 'validations' do
    it 'requires user' do
      expect(build(:project, user: nil)).not_to be_valid
    end

    it 'requires name' do
      expect(build(:project, name: nil)).not_to be_valid
    end

    it 'is not valid with name more than 72 symbols' do
      expect(build(:project, name: FFaker::String.from_regexp(/\A[a-zA-Z0-9]{73}\z/))).not_to be_valid
    end
    it 'is not valid with name less than 1 symbols' do
      expect(build(:project, name: '')).not_to be_valid
    end
  end
end
