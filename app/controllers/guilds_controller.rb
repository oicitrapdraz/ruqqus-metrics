# frozen_string_literal: true

class GuildsController < ApplicationController
  include Pagy::Backend

  # GET /guilds
  def index
    cache_key = CacheUtils.new.generate_cache_key(controller_path, action_name, index_params)

    @guild_index = Rails.cache.fetch('index_guild_indices', expires_in: 5.minutes) do
      Guild.select('id, ROW_NUMBER() OVER(ORDER BY subscribers_count DESC NULLS LAST, created_at DESC) as index').where('data IS NOT NULL').order('subscribers_count DESC NULLS LAST, created_at DESC').map { |result| [result.id, result.index] }.to_h
    end

    @pagy, @guilds = Rails.cache.fetch(cache_key, expires_in: 5.minutes) do
      pagy(Guild.search(search_params).where('data IS NOT NULL').order('subscribers_count DESC NULLS LAST, created_at DESC'), items: 10)
    end

    @created_guild_last_week = Rails.cache.fetch('index_date_statistics', expires_in: 5.minutes) do
      Guild.where("to_timestamp((data->>'created_utc')::integer) > ?", 1.week.ago).count
    end

    @status_statistics = Rails.cache.fetch('index_status_statistics', expires_in: 5.minutes) do
      {
        is_banned: Guild.where("data->>'is_banned' = ?", 'true').count,
        over_18: Guild.where("data->>'over_18' = ?", 'true').count,
        is_private: Guild.where("data->>'is_private' = ?", 'true').count,
        is_restricted: Guild.where("data->>'is_restricted' = ?", 'true').count
      }
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
