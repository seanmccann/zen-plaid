module Plaid
  class Auth
    def self.add(params)
      Plaid.request(:post, '/auth', Plaid::Util.credentials_params(params))
    end
  end
end
