class TracksController < ApplicationController
  def new
    @track = Track.new
  end

  def create
    @track = Track.new(track_params)

    if @track.save
      redirect_to runlog_index_path
    else
      render :new
    end
  end

  private

    def track_params
      params.require(:track).permit(:name, :gpx)
    end
end
