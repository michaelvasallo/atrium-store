class GamesController < ApplicationController
  def index
    @games = Game.page(params[:page]).per(16).order('random()')

    filtering_params(params).each do |key, value|
      @games = @games.public_send(key, value) if value.present?
    end
  end

  def show
    @game = Game.find_by!(slug: params[:id])
  end

  private

  def filtering_params(params)
    params.slice(:genre, :discount_over, :months_ago, :query, :order_by)
  end
end
