class RunlogController < ApplicationController
  def index
    @runlogs = Runlog.runlog_index
  end

  def detail
    @runlogs = Runlog.where(run_count: params[:run_count]).order(:run_at)
  end
end
