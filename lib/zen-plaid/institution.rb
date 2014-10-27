module Plaid
  class Institution
    def self.all
      Plaid.request(:get, 'institutions')[:message]
    end

    def self.find(id)
      Plaid.request(:get, 'institutions/' + id )[:message]
    end
  end
end
