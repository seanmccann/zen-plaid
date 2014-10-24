module Plaid
  # This is used when a customer needs to be defined by the plaid access token.
  # Abstracting as a class makes it easier since we wont have to redefine the access_token over and over.
  class Customer

    BASE_URL = 'https://tartan.plaid.com'

    # This initializes our instance variables, and sets up a new Customer class.
    def initialize
      Plaid::Configure::KEYS.each do |key|
        instance_variable_set(:"@#{key}", Plaid.instance_variable_get(:"@#{key}"))
      end
    end

    def mfa_auth_step(access_token, mfa, type, options={})
      options_string = options.to_json
      parse_response post('/auth/step', access_token: access_token, mfa: mfa, type: type, options: options_string)
    end

    def mfa_connect_step(access_token, mfa, type, options={})
      options_string = options.to_json
      parse_response post('/connect/step', access_token: access_token, mfa: mfa, type: type, options: options_string)
    end

    def get_transactions(access_token)
      parse_response(get('/connect', access_token),2)
    end

    def delete_account(access_token)
      parse_response(delete('/connect', access_token),3)
    end

    protected

    def parse_response(response,method=nil)
      parsed = JSON.parse(response)
      {code: response.code, message: parsed}
    end

    private

    def get(path,access_token)
      url = BASE_URL + path
      RestClient.get(url, params: {client_id: self.instance_variable_get(:'@client_id'), secret: self.instance_variable_get(:'@secret'), access_token: access_token})
    end

    def post(path, options={})
      url = BASE_URL + path
      RestClient.post url, options.merge!(auth)
    end

    def delete(path,access_token)
      url = BASE_URL + path
      RestClient.delete(url, params: {client_id: self.instance_variable_get(:'@client_id'), secret: self.instance_variable_get(:'@secret'), access_token: access_token})
    end

    def auth
      {client_id: self.instance_variable_get(:'@client_id'), secret: self.instance_variable_get(:'@secret')}
    end
  end
end
