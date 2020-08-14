# frozen_string_literal: true

class Guild < ApplicationRecord
  has_many :guild_histories

  validates_presence_of :name
  validates_presence_of :mods_count
  validates_presence_of :subscribers_count
end
