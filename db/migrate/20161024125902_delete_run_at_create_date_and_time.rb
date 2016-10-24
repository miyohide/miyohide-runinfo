class DeleteRunAtCreateDateAndTime < ActiveRecord::Migration
  def change
    remove_column :runlogs, :run_at, :datetime
    add_column :runlogs, :dateandtime, :string
  end
end
