class ReviewsController < ApplicationController
  before_action :set_review, only: [:edit, :update]

  def index
    @reviews = Review.all.order('created_at DESC')
  end

  def create
    review = Review.new(review_create_params)
    if review.save
      redirect_to book_path(review.book)
    else
      redirect_to book_path(review.book), alert: "本棚に登録できませんでした"
    end
  end

  def edit
    @book = @review.book
  end

  def update
    if @review.update(review_update_params)
      redirect_to edit_book_review_path
    else
      flash.now[:alert] = "レビューの更新ができませんでした"
      render :edit
    end
  end

  private

  def set_review
    @review = Review.find(params[:id])
  end

  def review_create_params
    params.require(:review).permit(:is_public, :reading_status).merge(user_id: current_user.id, book_id: params[:book_id])
  end

  def review_update_params
    params.require(:review).permit(:is_public, :reading_status, :rate, :body, :read_on, :comment)
  end
end
