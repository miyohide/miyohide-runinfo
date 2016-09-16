class RunlogController < ApplicationController
  def index
    @runlogs = Runlog.runlog_index
  end

  def show
  end
end
