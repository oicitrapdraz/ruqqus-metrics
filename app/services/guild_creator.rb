# frozen_string_literal: true

class GuildCreator
  attr_reader :name

  RUQQUS_API_URL = 'https://ruqqus.com/api/v1'

  def initialize(name)
    @name = name
  end

  def call
    create_guild if guild_name_is_valid
  end

  private

  def guild_name_is_valid
    guild_not_found && appears_in_ruqqus
  end

  def guild_not_found
    Guild.find_by('LOWER(name) = LOWER(?)', name).nil?
  end

  def appears_in_ruqqus
    access_token = API::AccessToken.new.call

    response = JSON.parse API::Request.new("#{RUQQUS_API_URL}/guild/#{name}", 'get', nil, { 'Authorization' => "Bearer #{access_token}" }).call

    @name = response['name']
  rescue StandardError => e
    Logg.error(e)
  end

  def create_guild
    Guild.create!(name)
  rescue StandardError => e
    Logg.error(e)
  end
end
