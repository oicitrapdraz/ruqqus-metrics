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

        ActiveRecord::Base.transaction do
          guild.update!(name: name, mods_count: mods_count, subscribers_count: subscribers_count, data: response)

          ids = ::Guild.order(subscribers_count: :desc, created_at: :desc).ids

          guild.guild_histories.create!(rank: ids.index(guild.id) + 1, mods_count: mods_count, subscribers_count: subscribers_count, data: response)
        end
      rescue StandardError => e
        Logg.error(e)
      end
    end
  end
end
