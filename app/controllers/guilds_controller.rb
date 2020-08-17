# frozen_string_literal: true

class GuildsController < ApplicationController
  include Pagy::Backend

  # GET /guilds
  def index
    cache_key = CacheUtils.new.generate_cache_key(controller_path, action_name, index_params)

    @pagy, @guilds = Rails.cache.fetch(cache_key, expires_in: 5.minutes) do
      pagy(Guild.search(search_params).where('data IS NOT NULL').order(subscribers_count: :desc, created_at: :desc), items: 10)
    end
  end

  # GET /guilds/1
  def show
    @guild = Guild.find_by!('LOWER(name) = LOWER(?)', params[:id])
    @pagy, @guild_histories = pagy(@guild.guild_histories.order(created_at: :desc).offset(1), items: 10)
  end

  private

  def index_params
    params.permit(:name, :is_banned, :over_18, :is_private, :is_restricted, :page)
  end

  def search_params
    params.permit(:name, :is_banned, :over_18, :is_private, :is_restricted)
  end
end
