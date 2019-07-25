require 'rails_helper'

RSpec.describe Task, type: :model do
  context 'associations' do
    it { should belong_to(:project) }
  end
  context 'validations' do
    it 'requires project' do
      expect(build(:task, project: nil)).not_to be_valid
    end

    it 'requires name' do
      expect(build(:task, name: nil)).not_to be_valid
    end

    it 'is not valid with name more than 72 symbols' do
      expect(build(:task, name: FFaker::String.from_regexp(/\A[a-zA-Z0-9]{73}\z/))).not_to be_valid
    end
    it 'is not valid with name less than 1 symbols' do
      expect(build(:task, name: '')).not_to be_valid
    end
  end
end
