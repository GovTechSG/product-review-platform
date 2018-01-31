class LikesController < ApiController
  include SwaggerDocs::Likes

  before_action :set_like, only: [:show, :update, :destroy]
  before_action :authenticate_user!

  # GET /reviews/:review_id/likes
  def index
    @likes = Like.where(review_id: params[:review_id])

    render json: @likes, methods: [:agency]
  end

  # GET /likes/1
  def show
    render json: @like
  end

  # POST /reviews/:review_id/likes
  def create
    @like = Like.new(create_params)

    if @like.save
      render json: @like, status: :created, location: @like
    else
      render json: @like.errors, status: :unprocessable_entity
    end
  end

  # DELETE /likes/1
  def destroy
    @like.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_like
      @like = Like.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def create_params
      params.require(:like).permit(:agency_id).merge(review_id: params[:review_id])
    end
end
