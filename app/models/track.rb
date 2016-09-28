class Track < ActiveRecord::Base
  has_attached_file :gpx
  validates_attachment :gpx, content_type: { content_type: ["text/plain"]}

  before_save :parse_file

  def parse_file
    tempfile = gpx.queued_for_write[:original].read
    tempfile.split("\n").each do |line|
      items = line.chomp.gsub(/{/, "").gsub(/}/, "").split(",")
      date_and_time = Time.parse(items[0].split(":", 2)[1])
      temp = items[1].split(":")[1]
      keido = items[5].split(":")[1].gsub(/\"/, '')
      ido = items[6].split(":")[1].gsub(/\"/, '')

      if ido.present? && keido.present?
        Runlog.create(run_count: name, run_at: date_and_time, temperature: temp,
                      latitude: keido.to_f/100.0, longitude: ido.to_f/100.0)
      end
    end
  end
end
