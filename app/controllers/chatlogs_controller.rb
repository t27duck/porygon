class ChatlogsController < ApplicationController
  before_action :authenticate_user!
  before_action :check_params, only: :show

  def index
  end

  def show
    @channel  = "##{params[:channel]}"
    @date     = Date.strptime(params[:date], "%Y%m%d")

    @logs = RawChatLog.where(
      channel: @channel,
      created_on: @date
    ).order(:created_at).page(params[:page]).per(25)
  end

  private ######################################################################

  def check_params
    if params[:channel].blank? || params[:date].blank?
      redirect_to chatlogs_path, error: 'Missing channel and date'
      return
    end
  end
end
