# frozen_string_literal: true

class GuildsController < ApplicationController
  include Pagy::Backend

  # GET /guilds
  def index
    @guild_index = Rails.cache.fetch('index_guild_indices', expires_in: 5.minutes) do
      Guild.select('id, ROW_NUMBER() OVER(ORDER BY subscribers_count DESC NULLS LAST, created_at DESC) as index').where('data IS NOT NULL').order('subscribers_count DESC NULLS LAST, created_at DESC').map { |result| [result.id, result.index] }.to_h
    end

    cache_key = CacheUtils.new.generate_cache_key(controller_path, action_name, index_params)

    @pagy, @guilds = Rails.cache.fetch(cache_key, expires_in: 5.minutes) do
      pagy(Guild.search(search_params).where('data IS NOT NULL').order('subscribers_count DESC NULLS LAST, created_at DESC'), items: 10, size: [1, 0, 0, 1])
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

  # GET /growth
  def growth
    @top_15_week_growth_guilds, @top_15_month_growth_guilds = Rails.cache.fetch('guild_growth', expires_in: 5.minutes) do
      [Guild.where('week_growth IS NOT NULL').order(week_growth: :desc).limit(15), Guild.where('month_growth IS NOT NULL').order(month_growth: :desc).limit(15)]
    end
  end

  # GET /guilds/1
  def show
    @guild = Guild.find_by!('LOWER(name) = LOWER(?)', show_params[:id])

    cache_key = CacheUtils.new.generate_cache_key(controller_path, action_name, show_params)

    @pagy, @guild_histories = Rails.cache.fetch(cache_key, expires_in: 5.minutes) do
      pagy(@guild.guild_histories.order(created_at: :desc), items: 5, size: [1, 0, 0, 1])
    end

    @data_series = Rails.cache.fetch("chart_#{show_params[:id]}_2", expires_in: 5.seconds) do
      [
        {
          name: 'Subscribers Count',
          data: @guild_histories.pluck("TO_CHAR(created_at, 'DD/MM/YYYY HH:MM:SS'), subscribers_count").reverse
        }
      ]
    end
  end

  private

  def show_params
    params.permit(:id, :page)
  end

  def index_params
    params.permit(:name, :is_banned, :over_18, :is_private, :is_restricted, :page)
  end

  def search_params
    params.permit(:name, :is_banned, :over_18, :is_private, :is_restricted)
  end
end
