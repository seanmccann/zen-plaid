module Plaid
  class Entity
    def self.find(id)
      Plaid.request(:get, 'entities/' + id )[:message]
    end
  end
end
