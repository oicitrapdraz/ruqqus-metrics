# frozen_string_literal: true

require 'net/http'

module API
  class Request
    attr_reader :url, :method, :body, :headers

    ACCEPTED_METHODS = %w[get post].freeze

    def initialize(url, method, body = nil, headers = nil)
      @url = url
      @method = method
      @body = body
      @headers = headers
    end

    def call
      uri = URI.parse(URI.escape(url))

      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_PEER

      net_http = "Net::HTTP::#{method.capitalize}".constantize

      final_uri = if uri.query
                    "#{uri.path}?#{uri.query}"
                  else
                    uri.path
                  end

      request = net_http.new(uri)

      headers.each { |key, value| request[key] = value if key.present? && value.present? } if headers

      request.body = body.to_json if body

      http.request(request).body
    rescue StandardError => e
      Logg.error(e)
    end
  end
end
