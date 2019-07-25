class CommentSerializer
  include FastJsonapi::ObjectSerializer

  belongs_to :task
  attributes :text, :attachment

  attribute :attachment_url do |object|
    Rails.application.routes.url_helpers.rails_blob_url(object.attachment) if object.attachment.attached?
  end
end
