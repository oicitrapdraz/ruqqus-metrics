# frozen_string_literal: true

require 'open-uri'

class ImageDownloader
  attr_reader :guild

  def initialize(guild)
    @guild = guild
  end

  def call
    download_guild_logo
  end

  private

  def download_guild_logo
    profile_url = guild.data&.[]('profile_url')

    return if profile_url.nil?

    logo_path = File.join(Dir.pwd, 'public', 'guild_logos', guild.id.to_s)

    IO.copy_stream(open(profile_url), logo_path)
    guild.update(logo_path: File.join('/', 'guild_logos', guild.id.to_s))
  rescue StandardError => e
    Logg.error(e)
  end
end
