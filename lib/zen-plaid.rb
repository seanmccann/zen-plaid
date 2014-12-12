require 'logger'
require 'oj'
require 'rest_client'

require 'zen-plaid/configuration'
require 'zen-plaid/util'
require 'zen-plaid/version'

require 'zen-plaid/auth'
require 'zen-plaid/balance'
require 'zen-plaid/category'
require 'zen-plaid/connect'
require 'zen-plaid/entity'
require 'zen-plaid/institution'

module Plaid
  def self.uri_encode(params)
    Util.flatten_params(params).
      map { |k,v| "#{k}=#{Util.url_encode(v)}" }.join('&')
  end

  def self.handle_api_error(rcode, rbody)
    error_obj = Util.symbolize_names(Oj.load(rbody))

    {code: rcode, error: error_obj}
  end

  def self.parse(response)
    begin
      response = Util.symbolize_names(Oj.load(response.body))
    rescue Oj::ParseError
      raise general_api_error(response.code, response.body)
    rescue ArgumentError
      response = {error: true}
    end
  end

  def self.api_url(url='')
    api_base + url
  end

  def self.api_base
    if Plaid.configuration.environment == 'production'
      'https://api.plaid.com/'
    else
      'https://tartan.plaid.com/'
    end
  end

  def self.request(method, url, params={}, headers={})
    request_opts = { verify_ssl: false }
    url = api_url(url)
    params = params.merge!(auth)

    case method.to_s.downcase.to_sym
    when :get, :head, :delete
      # Make params into GET parameters
      url += "#{URI.parse(url).query ? '&' : '?'}#{uri_encode(params)}" if params && params.any?
      payload = nil
    else
      payload = uri_encode(params)
    end

    request_opts.update(headers: headers,
                        method: method,
                        open_timeout: 30,
                        payload: payload,
                        url: url,
                        timeout: 80)

    begin
      response = RestClient::Request.execute(request_opts)
      log_message = Oj.dump(request_opts.merge!({response: response, response_code: response.code}))
      Plaid.configuration.logger.info log_message
      return {code: response.code, message: parse(response)}
    rescue RestClient::ExceptionWithResponse => e
      return handle_api_error(e.http_code, e.http_body)
    end
  end

  def self.auth
    {client_id: Plaid.configuration.client_id, secret: Plaid.configuration.secret}
  end
end
