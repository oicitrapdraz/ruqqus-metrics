# frozen_string_literal: true

class Guild < ApplicationRecord
  has_many :guild_histories

  validates_presence_of :name
end
