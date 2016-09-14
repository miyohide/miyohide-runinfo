class CreateRunlogs < ActiveRecord::Migration
  def change
    create_table :runlogs do |t|
      t.string :run_count, null: false
      t.datetime :run_at, null: false
      t.string :temperature, null: false
      t.string :latitude, null: false
      t.string :longitude, null: false

      t.timestamps null: false
    end
  end
end
