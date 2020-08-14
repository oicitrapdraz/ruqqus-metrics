# frozen_string_literal: true

module Scraper
  class Guild
    def call
      page = 1

      loop do
        Logg.info("Requesting #{RUQQUS_GUILDS_URL}&page=#{page}")
        parsed_body = Nokogiri::HTML API::Request.new("#{RUQQUS_GUILDS_URL}&page=#{page}", 'get').call

        guild_cards = parsed_body.css('.card.h-100').css('.card-title').css('a')

        break if guild_cards.count.zero?

        guild_cards.each do |guild|
          guild_name = CGI.escape guild['href'].split('+').last.strip

          ::Guild.find_or_create_by_insensitive_name!(guild_name)
        end

        page += 1
      end
    rescue StandardError => e
      Logg.error(e)
    end
  end
end
