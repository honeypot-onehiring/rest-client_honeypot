# frozen_string_literal: true

require 'json'
require 'securerandom'
require 'restclient'

# rubocop:disable Style/Documentation
module RestClient
  def self.post(url, payload, headers = {}, &block)
    payload, headers = with_json(payload, headers)
    RestClient::Request.execute(method: :post, url: url, payload: payload, headers: headers, &block)
  end

  def self.patch(url, payload, headers = {}, &block)
    payload, headers = with_json(payload, headers)
    RestClient::Request.execute(method: :post, url: url, payload: payload, headers: headers, &block)
  end

  def self.put(url, payload, headers = {}, &block)
    payload, headers = with_json(payload, headers)
    RestClient::Request.execute(method: :post, url: url, payload: payload, headers: headers, &block)
  end

  def self.with_json(payload, headers)
    if payload.is_a?(Hash) && payload[:headers].present?
      payload_headers = payload.delete(:headers)
      headers.merge!(payload_headers)
    end

    if payload.is_a?(Hash) && payload[:json].present?
      payload = payload.delete(:json).to_json
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

module RestClient
  class Request
    def self.execute(args, &block)
      # unfreeze frozen headers
      args[:headers] = args[:headers].dup if args[:headers].frozen?

      args[:start_time] = Time.zone.now
      args[:headers] = args
      args[:headers]['x-request-id'] ||= SecureRandom.uuid

      response = new(args).execute(&block)
      log_request(args, response)
      response
    rescue RestClient::Exception => e
      log_request(args, e.response)

      raise
    end

    def self.log_request(args, response)
      start_time = args.delete(:start_time)
      request_id = args[:headers]['x-request-id']
      method = args[:method].to_s.upcase
      url = args[:url]
      body = args[:payload].is_a?(String) ? args[:payload].squish : args[:payload]

      code = response&.code
      response_body = response.body&.squish
      duration = start_time ? ((Time.zone.now - start_time) * 1000).round(0) : nil
      message = "RestClient: Request with ID: #{request_id} #{method} #{url}"
      message += " with body: \"#{body}\"" if body
      message += " returned #{code}" if code
      message += " and took #{duration}ms" if duration

      Rails.logger.info(message)
      Rails.logger.info("RestClient: Response payload \"#{response_body}\"")
    end
  end
end
# rubocop:enable Style/Documentation
