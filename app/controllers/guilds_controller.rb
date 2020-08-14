class GuildsController < ApplicationController
  before_action :set_guild, only: %i[show edit update destroy]

  # GET /guilds
  def index
    @guilds = Guild.order(subscribers_count: :desc, created_at: :desc)
  end

  # GET /guilds/1
  def show; end
end
