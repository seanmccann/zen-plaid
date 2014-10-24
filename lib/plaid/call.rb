module Plaid
  class Call

    BASE_URL = 'https://tartan.plaid.com/'

    # This initializes our instance variables, and sets up a new Customer class.
    def initialize
      Plaid::Configure::KEYS.each do |key|
        instance_variable_set(:"@#{key}", Plaid.instance_variable_get(:"@#{key}"))
      end
    end

    # This is a specific route for auth,
    # it returns specific acct info
    def add_account_auth(type, username, password, pin=nil, email=nil)
      parse_auth_response(post('/connect', type, username, password, pin, email))
    end

    # This is a specific route for connect,
    # it returns transaction information
    def add_account_connect(type, username, password, pin=nil, email=nil)
      parse_connect_response(post('/connect', type, username, password, pin, email))
    end

    def get_place(id)
      parse_place(get('entities/',id))
    end

    def get_institutions
      parse_generic_response(get('institutions/'))
    end

    def get_institution(id)
      parse_generic_response(get('institutions/', id))
    end

    protected

    # Specific parser for auth response
    def parse_auth_response(response)
      parsed = JSON.parse(response)
      {code: response.code, message: parsed}
    end

    def parse_connect_response(response)
      parsed = JSON.parse(response)
      {code: response.code, message: parsed}
    end

    def parse_generic_response(response)
      parsed = JSON.parse(response)
      {code: response.code, message: parsed}
    end

    def parse_place(response)
      parsed = JSON.parse(response)
      {code: response.code, category: parsed['category'], name: parsed['name'], id: parsed['_id'], phone: parsed['meta']['contact']['telephone'], location: parsed['meta']['location']}
    end

    private

    def post(path, type, username, password, pin=nil, email=nil)
      url = BASE_URL + path
      params =  {type: type, credentials: {username: username, password: password}}
      params[:credentials][:pin] = pin if pin
      params[:email] = email if email

      RestClient.post url, params.merge!(auth)
    end

    def get(path,id="")
      url = BASE_URL + path + id
      RestClient.get(url)
    end

    def auth
      {client_id: self.instance_variable_get(:'@client_id'), secret: self.instance_variable_get(:'@secret')}
    end
  end
end
