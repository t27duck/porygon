class ChatlogsController < ApplicationController
  before_action :authenticate_user!

  def index
    @channels = RawChatLog.pluck(Arel.sql('DISTINCT channel'))
  end

  def show
    @channel  = "##{params[:channel]}"
    @date     = Date.strptime(params[:date], "%Y%m%d")

    @logs = RawChatLog.where(
      channel: @channel,
      created_on: @date
    ).order(:created_at).page(params[:page]).per(25)
  end
end
