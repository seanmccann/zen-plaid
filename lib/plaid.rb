require 'rest_client'

require 'plaid/version'
require 'plaid/configuration'
require 'plaid/util'

require 'plaid/auth'
require 'plaid/connect'
require 'plaid/institution'
require 'plaid/category'
require 'plaid/entity'
require 'plaid/balance'

module Plaid
  def self.uri_encode(params)
    Util.flatten_params(params).
      map { |k,v| "#{k}=#{Util.url_encode(v)}" }.join('&')
  end

  def self.handle_api_error(rcode, rbody)
    error_obj = Util.symbolize_names(JSON.parse(rbody))

    {code: rcode, error: error_obj}
  end

  def self.parse(response)
    begin
      response = JSON.parse(response.body, symbolize_names: true)
    rescue JSON::ParserError
      raise general_api_error(response.code, response.body)
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

    case method.to_s.downcase.to_sym
    when :get, :head, :delete
      # Make params into GET parameters
      url += "#{URI.parse(url).query ? '&' : '?'}#{uri_encode(params)}" if params && params.any?
      payload = nil
    else
      payload = uri_encode(params.merge!(auth))
    end

    request_opts.update(headers: headers,
                        method: method,
                        open_timeout: 30,
                        payload: payload,
                        url: url,
                        timeout: 80)

    begin
      response = RestClient::Request.execute(request_opts)
      return {code: response.code, message: parse(response)}
    rescue RestClient::ExceptionWithResponse => e
      return handle_api_error(e.http_code, e.http_body)
    end
  end

  def self.auth
    {client_id: Plaid.configuration.client_id, secret: Plaid.configuration.secret}
  end
end
