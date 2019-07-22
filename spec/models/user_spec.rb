require 'rails_helper'

RSpec.describe User, type: :model do
  context 'validations' do
    context 'presence' do
      it 'requires email' do
        expect(build(:user, email: nil)).not_to be_valid
      end

      it 'requires username' do
        expect(build(:user, username: nil)).not_to be_valid
      end

      it 'requires password' do
        expect(build(:user, password: nil)).not_to be_valid
      end
    end

    context 'email' do
      it 'is invalid with duplicated email' do
        create(:user, email: 'test@test.com')
        expect(build(:user, email: 'test@test.com')).not_to be_valid
      end

      it 'is invalid with wrong format' do
        expect(build(:user, email: 'asfasdf')).not_to be_valid
        expect(build(:user, email: 'asfasdf @wqedqwe.com')).not_to be_valid
        expect(build(:user, email: 'asfasdf@wqedqwe')).not_to be_valid
      end

      it 'is not case sensitive' do
        create(:user, email: 'CAPITAL@EMAIL.com')
        expect(build(:user, email: 'capital@email.com')).not_to be_valid
      end

      it 'is invalid with more than 63 symbols' do
        expect(build(:user, email: "#{FFaker::String.from_regexp(/\A[a-zA-Z0-9]{55}\z/)}@mail.com")).not_to be_valid
      end
    end

    context 'password' do
      it 'requires minimum 8 symbols' do
        expect(build(:user, password: '123456')).not_to be_valid
      end

      it 'is invalid with more than 72 symbols' do
        expect(build(:user, password: FFaker::String.from_regexp(/\A[a-zA-Z0-9]{73}\z/))).not_to be_valid
      end

      it 'is not allowed blank' do
        expect(build(:user, password: '')).not_to be_valid
      end
    end

    context 'email' do
      it 'is invalid with duplicated username' do
        create(:user, username: 'test')
        expect(build(:user, username: 'test')).not_to be_valid
      end

      it 'requires minimum 3 symbols' do
        expect(build(:user, username: '12')).not_to be_valid
      end

      it 'is invalid with more than 50 symbols' do
        expect(build(:user, username: FFaker::String.from_regexp(/\A[a-zA-Z0-9]{51}\z/))).not_to be_valid
      end
    end
  end
end
