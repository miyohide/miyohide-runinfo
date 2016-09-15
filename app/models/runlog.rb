class Runlog < ActiveRecord::Base
  def self.runlog_index
    run_at_max = group(:run_count).maximum(:run_at)
    run_at_min = group(:run_count).minimum(:run_at)

    rval = {}
    run_at_max.each do |key, val|
      rval[key] = {max: val, min: run_at_min[key]}
    end
    rval
  end
end
