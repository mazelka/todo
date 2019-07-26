module AttachmentUrlHelper
  def blob_for(file)
    ActiveStorage::Blob.create_after_upload!(
      io: File.open(Rails.root.join('spec', 'support', 'assets', file), 'rb'),
      filename: file,
      content_type: 'image/jpeg'
    )
  end
end
