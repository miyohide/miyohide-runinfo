class DeleteId < ActiveRecord::Migration
  def change
    remove_column :runlogs, :id, :integer
  end
end
