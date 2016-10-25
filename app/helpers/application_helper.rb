module ApplicationHelper
  def utc2jst(time)
    time.in_time_zone('Tokyo') unless time.nil?
  end
end
