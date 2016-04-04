class NickWhitelistsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_nick_whitelist, only: [:show, :edit, :update, :destroy]

  def index
    @nick_whitelists = NickWhitelist.all
  end

  def show
  end

  def new
    @nick_whitelist = NickWhitelist.new
  end

  def edit
  end

  def create
    @nick_whitelist = NickWhitelist.new(nick_whitelist_params)

    if @nick_whitelist.save
      redirect_to @nick_whitelist, notice: 'Nick whitelist was successfully created.'
    else
      render :new
    end
  end

  def update
    if @nick_whitelist.update(nick_whitelist_params)
      redirect_to @nick_whitelist, notice: 'Nick whitelist was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @nick_whitelist.destroy
    redirect_to nick_whitelists_url, notice: 'Nick whitelist was successfully destroyed.'
  end

  private ######################################################################

  def set_nick_whitelist
    @nick_whitelist = NickWhitelist.find(params[:id])
  end

  def nick_whitelist_params
    params.require(:nick_whitelist).permit(:nick)
  end
end
