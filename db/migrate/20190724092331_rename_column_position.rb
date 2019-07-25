class RenameColumnPosition < ActiveRecord::Migration[5.2]
  def change
    rename_column :tasks, :priority, :position
  end
end
