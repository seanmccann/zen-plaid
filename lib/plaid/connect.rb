module Plaid
  class Connect
    def self.add(params)
      Plaid.request(:post, '/connect', params)
    end

    def self.mfa_step(params)
      Plaid.request(:post, '/connect/step', params)
    end
  end
end
