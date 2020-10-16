class Api::V1::Admin::ArticlesController < ApplicationController
  before_action :authenticate_user!
  before_action :role_journalist?

  def create
    article = current_user.articles.create(article_params)
    if article.persisted?
      render json: { message: "successfully saved" }
    else
      error_message(article.errors)
    end
  end

  private

  def article_params
    params.require(:article).permit(:title, :teaser, :content, :category)
  end

  def role_journalist?
    unless current_user.role == "journalist"
      restrict_access
    end
  end

  def restrict_access
    render json: { message: "Sorry, you don't have the necessary permission" }, status: :unauthorized
  end
end
