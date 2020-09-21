# frozen_string_literal: true

class Guild < ApplicationRecord
  has_many :guild_histories

  validates_presence_of :name
  validates_uniqueness_of :name, case_sensitive: false

  scope :subscribers_count_order, -> { order('subscribers_count DESC NULLS LAST, created_at DESC') }

  scope :search, lambda { |params|
    params.reject! { |_, v| v.blank? }

    scope = all
    scope = scope.where('name ILIKE ?', "%#{params[:name]}%") if params[:name]
    scope = scope.where("data->>'description' ILIKE ?", "%#{params[:description]}%") if params[:description]
    scope = scope.where("data->>'is_banned' = ?", params[:is_banned]) if params[:is_banned]
    scope = scope.where("data->>'over_18' = ?", params[:over_18]) if params[:over_18]
    scope = scope.where("data->>'is_private' = ?", params[:is_private]) if params[:is_private]
    scope = scope.where("data->>'is_restricted' = ?", params[:is_restricted]) if params[:is_restricted]

    scope
  }

  def update_growth
    month_histories = guild_histories.where('created_at > ?', 1.month.ago).order(:created_at).to_a

    return if month_histories.count < 2

    month_growth = month_histories.last.subscribers_count - month_histories.first.subscribers_count

    update(month_growth: month_growth)

    week_histories = guild_histories.where('created_at > ?', 1.week.ago).order(:created_at).to_a

    return if week_histories.count < 2

    week_growth = week_histories.last.subscribers_count - week_histories.first.subscribers_count

    update(week_growth: week_growth)
  rescue StandardError => e
    Logg.error(e)
  end
end
