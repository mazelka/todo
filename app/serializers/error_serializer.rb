class ErrorSerializer < ActiveModel::Serializer::ErrorSerializer
  attributes :detail, :title, :source, :pointer, :links
end
