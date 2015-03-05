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

    def self.update_user(params)
      Plaid.request(:patch, '/connect', params)
    end

    def self.update_mfa_step(params)
      Plaid.request(:patch, '/connect/step', params)
    end
  end
end
