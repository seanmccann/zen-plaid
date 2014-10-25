module Plaid
  class Balance
    def self.get(access_token)
      Plaid.request(:post, '/balance/', {access_token: access_token} )
    end
  end
end
