# frozen_string_literal: true

module API
  module Importer
    class Guild
      attr_reader :guild

      def initialize(guild)
        @guild = guild
      end

      def call
        update_guild_data(request_ruqqus)
      end

      private

      def request_ruqqus
        API::Request.new("#{RUQQUS_API_URL}/guild/#{guild.name}", 'get').call
      end

      def update_guild_data(response)
        name = response['name']
        mods_count = response['mods_count']
        subscribers_count = response['subscriber_count']

        guild.update!(name: name, mods_count: mods_count, subscribers_count: subscribers_count, data: response)
        guild.guild_histories.create!(mods_count: mods_count, subscribers_count: subscribers_count, data: response)
      rescue StandardError => e
        Logg.error(e)
      end
    end
  end
end
