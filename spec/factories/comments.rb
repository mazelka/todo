FactoryBot.define do
  factory :comment do
    text { FFaker::Name.name + FFaker::Name.name }
    task
  end

  trait :with_jpg_attachment do
    attachment { fixture_file_upload(Rails.root.join('spec', 'support', 'assets', 'photo.jpg'), 'image/jpg') }
  end

  trait :with_png_attachment do
    attachment { fixture_file_upload(Rails.root.join('spec', 'support', 'assets', 'bdd-cycle.png'), 'image/png') }
  end

  trait :with_jpeg_attachment do
    attachment { fixture_file_upload(Rails.root.join('spec', 'support', 'assets', '1527840855653.JPEG'), 'image/jpeg') }
  end

  trait :with_big_attachment do
    attachment { fixture_file_upload(Rails.root.join('spec', 'support', 'assets', '2019-05-21 19.47.08.jpg'), 'image/jpg') }
  end

  trait :with_pdf_attachment do
    attachment { fixture_file_upload(Rails.root.join('spec', 'support', 'assets', '18-CTFL-130229-06.pdf'), 'image/pdf') }
  end
end
