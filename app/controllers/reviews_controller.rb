class ReviewsController < ApplicationController
  include SwaggerDocs::Reviews
  before_action :doorkeeper_authorize!

  before_action only: [:index] { set_reviewable(true) }
  before_action only: [:destroy, :show] { set_review }
  before_action only: [:create] do
    require_params(true)
    set_reviewable(true) unless performed?
    transform_params unless performed?
    set_reviewer(true) unless performed?
    set_grant(true) unless performed?
    set_strength(false) unless performed?
  end
  before_action only: [:update] do
    require_params(false)
    transform_params unless performed?
    set_review unless performed?
    set_reviewer(false) unless performed?
    set_grant(false) unless performed?
    set_strength(false) unless performed?
  end

  # GET /products/:product_id/reviews
  # GET /services/:service_id/reviews
  def index
    @reviews = @reviewable.reviews.kept.page params[:page]
    render json: @reviews, methods: [:company, :likes_count, :comments_count, :strengths], has_type: false
  end

  # GET /reviews/1
  def show
    render json: @review, methods: [:company, :likes_count, :comments_count, :strengths], has_type: false
  end

  # POST /products/:product_id/reviews
  # POST /services/:service_id/reviews
  def create
    @review = Review.new(@whitelisted)
    # Update aggregate score of associated vendor company
    company = add_company_score(@reviewable.company, @score) if @score

    if @review.save && (company.nil? || company.save)
      render json: @review, status: :created, location: @review, has_type: false
    else
      render json: @review.errors.messages, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /reviews/1
  def update
    company = nil
    # Store update_params in a temp variable to avoid
    # repeatedly calling the method
    if !@score.nil?
      # Update aggregate score of associated vendor company
      company = update_company_score(@review.reviewable.company, @review.score, @score)
    end
    if @review.update(@whitelisted) && (company.nil? || company.save)
      render json: @review, has_type: false
    else
      render json: @review.errors.messages, status: :unprocessable_entity
    end
  end

  # DELETE /reviews/1
  def destroy
    # Update aggregate score of associated vendor company
    company = subtract_company_score(@review.reviewable.company, @review.score)
    @review.discard && company.save
  end

  private
    def require_params(required)
      @whitelisted = params.fetch(:review, nil)
      if @whitelisted.blank?
        render_error(400, "#{I18n.t('general_error.params_missing_key')}": [I18n.t('general_error.params_missing_value', model: "review")])
        return
      else
        @whitelisted = @whitelisted.permit(:score, :content, :from_id,
                                           :from_type, :grant_id, :strength_ids => [])
      end
      if required
        param_required_foreign_keys.each do |foreign_key|
          if @whitelisted[foreign_key].blank?
            render_error(400, "#{I18n.t('general_error.params_missing_key')}": [I18n.t('general_error.params_missing_value', model: foreign_key)])
            break
          end
        end
      end
    end

    def transform_params
      convertable_inputs.each do |input|
        @whitelisted[input[input.keys.first]] = @whitelisted.delete(input.keys.first) if @whitelisted[input.keys.first].present?
      end
    end

    def set_reviewable(required)
      reviewable = find_class_in_hash(params, "Reviewable", false)
      if required && reviewable.nil?
        render_error(400, "#{I18n.t('general_error.params_missing_key')}": [I18n.t('general_error.params_missing_value', model: @input_type + "_id")])
        return
      elsif !reviewable.nil?
        @reviewable = find_record(reviewable[:type], reviewable[:id])
        if invalid_record(@reviewable)
          render_error(404, "#{I18n.t('review.reviewable', model: reviewable[:type].to_s + '_id')}": [I18n.t('general_error.not_found')])
          return
        end
        unless @whitelisted.nil?
          @whitelisted[:reviewable_type] = reviewable[:type].to_s
          @whitelisted[:reviewable_id] = reviewable[:id]
        end
      end
    end

    def set_review
      if params[:id].present?
        @review = find_record(Review, params[:id])
        render_error(404, "#{I18n.t('review.key_id')}": [I18n.t('general_error.not_found')]) if invalid_record(@review)
      else
        render_error(400, "#{I18n.t('general_error.params_missing_key')}": [I18n.t('general_error.params_missing_value', model: "id")])
      end
    end

    def set_reviewer(required)
      reviewer_class = find_class_in_hash(@whitelisted, "Reviewer", true)
      if required && !provided
        render_error(400, "#{I18n.t('general_error.params_missing_key')}": [I18n.t('general_error.params_missing_value', model: @input_type + "_id")])
        return
      elsif !reviewer_class.nil?
        get_reviewer(reviewer_class)
      elsif provided && reviewer_class.nil?
        render_error(422, "#{I18n.t('general_error.params_missing_key')}": [I18n.t('general_error.params_missing_value', model: "from_id/from_type")])

        return
      end
    end

    def get_reviewer(reviewer_class)
      reviewer = find_record(reviewer_class[:type], reviewer_class[:id])
      if invalid_record(reviewer)
        render_error(404, "#{I18n.t('general_error.from_id_key')}": [I18n.t('general_error.not_found')])
        return
      end
      @whitelisted[:reviewer_type] = reviewer_class[:type].to_s
      @whitelisted[:reviewer_id] = reviewer_class[:id]
    end

    def set_grant(required)
      if required && @whitelisted[:grant_id].blank?
        render_error(400, "#{I18n.t('general_error.params_missing_key')}": [I18n.t('general_error.params_missing_value', model: "grant_id")])
      elsif @whitelisted[:grant_id].present?
        grant = find_record(Grant, @whitelisted[:grant_id])
        render_error(404, "#{I18n.t('grant.key_id')}": [I18n.t('general_error.not_found')]) if invalid_record(grant)
      end
    end

    def set_strength(required)
      if required && @whitelisted[:strength_ids].blank?
        render_error(400, "#{I18n.t('general_error.params_missing_key')}": [I18n.t('general_error.params_missing_value', model: "strength_ids")])
      elsif @whitelisted[:strength_ids].present?
        @whitelisted[:strength_ids].each do |id|
          strength = find_record(Strength, id)
          if invalid_record(strength)
            render_error(404, "#{I18n.t('strength.key_id')}": [I18n.t('general_error.not_found')])
            break
          end
        end
      end
    end

    def find_class_in_hash(hash, superclass, type_in_params)
      hash.each do |name, value|
        if name =~ /(.+)_id$/
          @input_type = Regexp.last_match[1]
          actual_type = if type_in_params && hash["#{@input_type}_type"].present?
                          get_class_from_type(hash, "#{@input_type}_type")
                        else
                          @input_type.classify.safe_constantize
                        end
          return {type: actual_type, id: value} if !actual_type.nil? && actual_type.superclass.name == superclass
        end
      end
      nil
    end

    def get_class_from_type(param_hsh, type)
      param_hsh[type].classify.safe_constantize
    end

    def provided
      @whitelisted[:reviewer_type].present? || @whitelisted[:reviewer_id].present?
    end

    def invalid_record(record)
      record.nil? || !record.presence?
    end

    def find_record(record_type, id)
      record_type.find_by(id: id)
    end

    def param_required_foreign_keys
      [
        :from_id,
        :from_type,
        :grant_id
      ]
    end

    def convertable_inputs
      [
        {from_id: :reviewer_id},
        {from_type: :reviewer_type}
      ]
    end

    def add_company_score(company, score)
      company.aggregate_score = company.add_score(score)
      company
    end

    def update_company_score(company, old_score, updated_score)
      company.aggregate_score = company.update_score(old_score, updated_score)
      company
    end

    def subtract_company_score(company, score)
      company.aggregate_score = company.subtract_score(score)
      company
    end

    def validate_score_type
      score_param = params.require(:review).permit(:score)[:score]
      if score_param
        if score_param.is_a? String
          @score = Float(score_param)
        elsif score_param.is_a? Numeric
          @score = score_param
        else
          render_error(422, "#{I18n.t('score.key')}": [I18n.t('score.invalid')])
        end
      end
    rescue ArgumentError
      render_error(422, "#{I18n.t('score.key')}": [I18n.t('score.invalid')])
    end
end

