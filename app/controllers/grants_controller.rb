class GrantsController < ApplicationController
  before_action :set_grant, only: [:show, :update, :destroy]

  # GET /grants
  def index
    @grants = Grant.all

    render json: @grants
  end

  # GET /grants/1
  def show
    render json: @grant
  end

  # POST /grants
  def create
    @grant = Grant.new(grant_params)

    if @grant.save
      render json: @grant, status: :created, location: @grant
    else
      render json: @grant.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /grants/1
  def update
    if @grant.update(grant_params)
      render json: @grant
    else
      render json: @grant.errors, status: :unprocessable_entity
    end
  end

  # DELETE /grants/1
  def destroy
    @grant.destroy
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_grant
    @grant = Grant.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def grant_params
    params.require(:grant).permit(:name)
  end
end
