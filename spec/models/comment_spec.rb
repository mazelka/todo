require 'rails_helper'

RSpec.describe Comment, type: :model do
  context 'associations' do
    it { should belong_to(:task) }
  end
  context 'validations' do
    it 'requires task' do
      expect(build(:comment, task: nil)).not_to be_valid
    end

    context 'text' do
      it 'requires text' do
        expect(build(:comment, text: nil)).not_to be_valid
      end

      it 'is not valid with text more than 256 symbols' do
        expect(build(:comment, text: FFaker::String.from_regexp(/\A[a-zA-Z0-9]{257}\z/))).not_to be_valid
      end

      it 'is not valid with text less than 10 symbols' do
        expect(build(:comment, text: FFaker::String.from_regexp(/\A[a-zA-Z0-9]{9}\z/))).not_to be_valid
      end

      it 'is not valid with text less than 10 symbols' do
        expect(build(:comment, text: FFaker::String.from_regexp(/\A[a-zA-Z0-9]{9}\z/))).not_to be_valid
      end

      context 'attachment' do
        it 'allows jpg files' do
          expect(build(:comment, :with_jpg_attachment)).to be_valid
        end

        it 'allows jpeg files' do
          expect(build(:comment, :with_jpeg_attachment)).to be_valid
        end

        it 'allows png files' do
          expect(build(:comment, :with_png_attachment)).to be_valid
        end

        it 'is invalid with pdf files' do
          expect(build(:comment, :with_pdf_attachment)).not_to be_valid
        end

        it 'is invalid with files of size more then 10mb' do
          expect(build(:comment, :with_big_attachment)).not_to be_valid
        end
      end
    end
  end
end
