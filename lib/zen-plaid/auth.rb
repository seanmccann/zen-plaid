module Plaid
  class Auth
    def self.add(params)
      Plaid.request(:post, '/auth', params)
    end
  end
end
