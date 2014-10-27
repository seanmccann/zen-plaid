module Plaid
  class Connect
    def self.get(params)
      Plaid.request(:post, 'connect/get', params)
    end

    def self.add(params)
      Plaid.request(:post, 'connect', Plaid::Util.credentials_params(params))
    end

    def self.mfa_step(params)
      Plaid.request(:post, 'connect/step', params)
    end
  end
end
