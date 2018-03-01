class UsersController < ApplicationController
  include SwaggerDocs::Users
  before_action :doorkeeper_authorize!
  before_action :set_user, only: [:show, :update, :destroy]
  before_action :validate_user_pressence, only: [:show, :update, :destroy]

  # GET /users
  def index
    @users = User.kept

    render json: @users
  end

  # GET /users/1
  def show
    render json: @user
  end

  # POST /users
  def create
    @user = User.new(user_params)

    if @user.save
      render json: @user, status: :created, location: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /users/1
  def update
    if @user.update(user_params)
      render json: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # DELETE /users/1
  def destroy
    @user.discard
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find_by(id: params[:id])
  end

  def validate_user_pressence
    render_error(404) if @user.nil? || @user.discarded?
  end

  # Only allow a trusted parameter "white list" through.
  def user_params
    params.require(:user).permit(:name, :email, :number)
  end
end
