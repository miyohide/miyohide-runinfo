class RunlogController < ApplicationController
  def index
    @runlogs = Runlog.runlog_index
  end

  def detail
    @runlogs = Runlog.where(run_count: params[:run_count]).order(:run_at)
    @chart_data = Runlog.where(run_count: params[:run_count]).map{|runlog| [runlog.run_at.to_s, runlog.temperature.to_f]}
    @polyline = Runlog.to_polyline(params[:run_count])
  end

  def gpx_download
    send_data(Runlog.to_gpx(params[:run_count]),
      filename: "run_log_#{params[:run_count]}.gpx",
      type: "application/xml-gpx",
      disposition: "attachment")
  end
end
