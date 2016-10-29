class Runlog < ActiveRecord::Base
  def self.runlog_index
    run_at_max = group(:run_count).maximum(:dateandtime)
    run_at_min = group(:run_count).minimum(:dateandtime)

    rval = {}
    run_at_max.each do |key, val|
      rval[key] = {max: val, min: run_at_min[key]}
    end
    rval
  end

  def self.to_polyline(run_count)
    polyline = []
    where(run_count: run_count).each do |runlog|
      if runlog.latitude.length != 0 and runlog.longitude.length != 0
        polyline << {lat: runlog.latitude.to_f/100, lng: runlog.longitude.to_f/100}
      end
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
              xml.time(Time.parse(runlog.dateandtime).xmlschema)
            }
          end
        }
      }
    }
    ret
  end
end
