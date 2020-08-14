# frozen_string_literal: true

class Guild < ApplicationRecord
  has_many :guild_histories

  validates_presence_of :name
  validates_uniqueness_of :name, case_sensitive: false

  scope :find_or_create_by_insensitive_name!, lambda { |name|
    find_by('LOWER(name) = LOWER(?)', name) || create!(name: name)
  }
end
