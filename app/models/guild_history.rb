# frozen_string_literal: true

class GuildHistory < ApplicationRecord
  belongs_to :guild

  validates_presence_of :mods_count
  validates_presence_of :subscribers_count
end
