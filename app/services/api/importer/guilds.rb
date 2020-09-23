# frozen_string_literal: true

module API
  module Importer
    class Guilds
      RUQQUS_API_SCRAPING_GUILDS_URL = 'https://ruqqus.com/api/v1/guilds?sort=new'

      def call(minimun_scraped_pages: 3)
        current_page = 1

        loop do
          access_token = API::AccessToken.new.call

          Logg.info("Requesting #{RUQQUS_API_SCRAPING_GUILDS_URL}&page=#{current_page}")
          response = JSON.parse API::Request.new("#{RUQQUS_API_SCRAPING_GUILDS_URL}&page=#{current_page}", 'get', nil, { 'Authorization' => "Bearer #{access_token}" }).call

          response['data'].each do |guild|
            guild_name = guild['name']

            found_guild = ::Guild.find_by('LOWER(name) = LOWER(?)', guild_name)

            if found_guild && (current_page >= minimun_scraped_pages) && (response['data'].last.eql? guild)
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
end
