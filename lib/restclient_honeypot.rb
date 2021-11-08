# frozen_string_literal: true

require 'restclient'

# rubocop:disable Style/Documentation
module RestClient
  def self.post(url, payload, headers = {}, &block)
    payload, headers = with_json(payload, headers)
    super(url, payload, headers, &block)
  end

  def self.patch(url, payload, headers = {}, &block)
    payload, headers = with_json(payload, headers)
    super(url, payload, headers, &block)
  end

  def self.put(url, payload, headers = {}, &block)
    payload, headers = with_json(payload, headers)
    super(url, payload, headers, &block)
  end

  def self.with_json(payload, headers)
    if payload.is_a?(Hash) && payload[:headers].present?
      payload_headers = payload.delete(:headers)
      headers.merge!(payload_headers)
    end

    if payload.is_a?(Hash) && payload[:json].present?
      payload = payload.delete(:json)
      headers[:content_type] = :json
      headers[:accept] = :json
    end

    [payload, headers]
  end
end

module RestClient
  class Response
    def parsed_body(**params)
      JSON.parse(body, **params)
    end
  end
end
# rubocop:enable Style/Documentation
