# frozen_string_literal: true

class Guild < ApplicationRecord
  has_many :guild_histories

  validates_presence_of :name
  validates_uniqueness_of :name, case_sensitive: false

  scope :search, lambda { |params|
    params.reject! { |_, v| v.blank? }

    scope = all
    scope = scope.where('name ILIKE ?', "%#{params[:name]}%") if params[:name]
    scope = scope.where("data->>'is_banned' = ?", params[:is_banned]) if params[:is_banned]
    scope = scope.where("data->>'over_18' = ?", params[:over_18]) if params[:over_18]
    scope = scope.where("data->>'is_private' = ?", params[:is_private]) if params[:is_private]
    scope = scope.where("data->>'is_restricted' = ?", params[:is_restricted]) if params[:is_restricted]

    scope
  }
end
