class TracksController < ApplicationController
  def new
    @track = Track.new
  end

  def create
    @track = Track.new(track_params)

    respond_to do |format|
      if @track.save
        redirect_to runlog_index_path
      else
        render :new
      end
    end
  end

  private

    def track_params
      params.require(:track).permit(:name, :gpx)
    end
end
