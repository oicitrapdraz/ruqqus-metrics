# frozen_string_literal: true

class GuildsController < ApplicationController
  include Pagy::Backend

  # GET /guilds
  def index
    @guild_index = Rails.cache.fetch('index_guild_indices', expires_in: 5.minutes) do
      Guild.select('id, ROW_NUMBER() OVER(ORDER BY subscribers_count DESC NULLS LAST, created_at DESC) as index').where.not(data: nil).subscribers_count_order.map { |result| [result.id, result.index] }.to_h
    end

    cache_key = CacheUtils.new.generate_cache_key(controller_path, action_name, index_params)

    @pagy, @guilds = Rails.cache.fetch(cache_key, expires_in: 5.minutes) do
      pagy(Guild.search(search_params).where.not(data: nil).subscribers_count_order, items: 10, size: [1, 0, 0, 1])
    end

    @created_guild_last_week = Rails.cache.fetch('index_date_statistics', expires_in: 15.minutes) do
      Guild.where("to_timestamp((data->>'created_utc')::integer) > ?", 1.week.ago).count
    end

    @status_statistics = Rails.cache.fetch('index_status_statistics', expires_in: 15.minutes) do
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
      [Guild.where.not(week_growth: nil).order(week_growth: :desc).limit(15), Guild.where.not(month_growth: nil).order(month_growth: :desc).limit(15)]
    end
  end

  # GET /guilds/1
  def show
    @guild = Guild.find_by!('LOWER(name) = LOWER(?)', show_params[:id])

    cache_key = CacheUtils.new.generate_cache_key(controller_path, action_name, show_params)

    @pagy, @guild_histories = Rails.cache.fetch(cache_key, expires_in: 5.minutes) do
      pagy(@guild.guild_histories.order(created_at: :desc), items: 5, size: [1, 0, 0, 1])
    end

    if @guild_histories.size > 1
      hours_difference = (@guild_histories.first.created_at - @guild_histories.last.created_at).to_i / (60 * 60)
      subscribers_count_difference = @guild_histories.first.subscribers_count - @guild_histories.last.subscribers_count

      unless hours_difference.zero?
        @daily_average_growth = ((subscribers_count_difference / hours_difference.to_f) * 24).round(1)
      end
    end

    @data_series = Rails.cache.fetch("chart_#{cache_key}", expires_in: 5.minutes) do
      [
        {
          name: 'Subscribers Count',
          data: @guild_histories.pluck("TO_CHAR(created_at, 'MM/DD/YYYY HH24:MI:SS'), subscribers_count").reverse
        }
      ]
    end
  end

  # GET /guilds/1
  def new; end

  # POST /guilds
  def create
    if verify_recaptcha(response: create_params['g-recaptcha-response'])
      GuildCreator.new(create_params[:name]).call
      flash = { notice: 'Thanks for your contribution, if this Guild exists and is not in our database, it will be added in less than a day.' }
    else
      flash = { alert: 'Please solve the reCAPTCHA.' }
    end

    redirect_to new_guild_path, flash
  end

  private

  def show_params
    params.permit(:id, :page)
  end

  def index_params
    params.permit(:name, :description, :is_banned, :over_18, :is_private, :is_restricted, :page)
  end

  def search_params
    params.permit(:name, :description, :is_banned, :over_18, :is_private, :is_restricted)
  end

  def create_params
    params.permit(:name, 'g-recaptcha-response')
  end
end
