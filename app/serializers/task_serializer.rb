class TaskSerializer
  include FastJsonapi::ObjectSerializer
  attributes :name, :deadline, :position, :done
  belongs_to :project
end
