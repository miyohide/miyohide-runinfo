class RunlogController < ApplicationController
  def index
    @runlogs = Runlog.runlog_index
  end

  def detail
    @runlogs = Runlog.where(run_count: params[:run_count]).order(:run_at)
  end

  def gpx_download
    send_data(Runlog.to_gpx(params[:run_count]),
      filename: "run_log_#{params[:run_count]}.gpx",
      type: "application/xml-gpx",
      disposition: "attachment")
  end
end
