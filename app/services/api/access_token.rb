# frozen_string_literal: true

require 'net/http'

module API
  class AccessToken
    RUQQUS_API_REFRESH_TOKEN = 'https://ruqqus.com/oauth/grant?grant_type=refresh'

    def call
      Rails.cache.fetch('access_token', expires_in: 30.minutes) do
        body = {
          'client_id' => ENV['API_CLIENT_ID'],
          'client_secret' => ENV['API_CLIENT_SECRET'],
          'refresh_token' => ENV['API_REFRESH_TOKEN']
        }

        response = JSON.parse API::Request.new(RUQQUS_API_REFRESH_TOKEN, 'post', body).call

        response['access_token']
      end
    rescue StandardError => e
      Logg.error(e)
    end
  end
end
