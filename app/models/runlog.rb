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

  def self.to_polyline(run_count)
    polyline = []
    where(run_count: run_count).each do |runlog|
      polyline << {lat: runlog.latitude.to_f, lng: runlog.longitude.to_f, time: runlog.run_at.to_i}
    end
    polyline
  end

  def self.to_gpx(run_count)
    require 'builder/xmlmarkup'
    ret = ''
    xml = ::Builder::XmlMarkup.new(target: ret, indent: 4)
    xml.instruct!
    xml.gpx(creator: "miyohide") {
      xml.metadata {
        xml.time(Time.now.xmlschema)
      }
      xml.trk {
        xml.name(run_count)
        xml.type("running")
        xml.trkseg {
          where(run_count: run_count).each do |runlog|
            xml.trkpt(lat: runlog.latitude, lon: runlog.longitude) {
              xml.time(runlog.run_at.xmlschema)
            }
          end
        }
      }
    }
    ret
  end
end
