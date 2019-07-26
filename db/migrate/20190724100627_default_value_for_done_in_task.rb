class DefaultValueForDoneInTask < ActiveRecord::Migration[5.2]
  def change
    change_column :tasks, :done, :boolean, default: false
  end
end
