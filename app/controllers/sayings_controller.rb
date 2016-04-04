class SayingsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_saying, only: [:show, :edit, :update, :destroy]

  def index
    @sayings = Saying.order(:name)
  end

  def show
  end

  def new
    @saying = Saying.new
  end

  def edit
  end

  def create
    @saying = Saying.new(saying_params)

    if @saying.save
      redirect_to @saying, notice: 'Saying was successfully created.'
    else
      render :new
    end
  end

  def update
    if @saying.update(saying_params)
      redirect_to @saying, notice: 'Saying was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @saying.destroy
    redirect_to sayings_url, notice: 'Saying was successfully destroyed.'
  end

  private ######################################################################

  def set_saying
    @saying = Saying.find(params[:id])
  end

  def saying_params
    params.require(:saying).permit(
      :name, :pattern, :trigger_percentage, :enabled,
      responses_attributes: [:id, :content, :_destroy]
    )
  end
end
