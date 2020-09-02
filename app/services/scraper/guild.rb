# frozen_string_literal: true

module Scraper
  class Guild
    MINIMUM_SCRAPED_PAGES = 3
    RUQQUS_SCRAPING_GUILDS_URL = 'https://ruqqus.com/browse?sort=new'

    def call
      current_page = 1

      loop do
        Logg.info("Requesting #{RUQQUS_SCRAPING_GUILDS_URL}&page=#{current_page}")
        parsed_body = Nokogiri::HTML API::Request.new("#{RUQQUS_SCRAPING_GUILDS_URL}&page=#{current_page}", 'get').call

        guild_cards = parsed_body.css('.card.h-100').css('.card-title').css('a')

        break if guild_cards.count.zero?

        guild_cards.each do |guild|
          guild_name = CGI.escape guild['href'].split('+').last.strip

          found_guild = ::Guild.find_by('LOWER(name) = LOWER(?)', guild_name)

          if found_guild && (current_page > MINIMUM_SCRAPED_PAGES)
            return Logg.info('Stopping scrapper since the last guild was found and the minimun quota of pages were scraped')
          end

          ::Guild.create!(name: guild_name) unless found_guild
        end

        current_page += 1
      end
    rescue StandardError => e
      Logg.error(e)
    end
  end
end
