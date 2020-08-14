# frozen_string_literal: true

require 'net/http'

module API
  class Request
    attr_reader :url, :method

    ACCEPTED_METHODS = %w[get post].freeze

    def initialize(url, method)
      @url = url
      @method = method
    end

    def call
      uri = URI.parse(url)

      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_PEER

      net_http = "Net::HTTP::#{method.capitalize}".constantize

      response = net_http.new(uri.path)

      JSON.parse http.request(response).body
    rescue StandardError => e
      Logg.error(e)
    end
  end
end
