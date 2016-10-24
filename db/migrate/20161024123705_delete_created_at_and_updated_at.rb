class DeleteCreatedAtAndUpdatedAt < ActiveRecord::Migration
  def change
    remove_column :runlogs, :created_at, :datetime
    remove_column :runlogs, :updated_at, :datetime
  end
end
