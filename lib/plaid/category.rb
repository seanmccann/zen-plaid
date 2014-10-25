module Plaid
  class Category
    def self.all
      Plaid.request(:get, '/categories')[:message]
    end

    def self.find(id)
      Plaid.request(:get, '/categories/' + id )[:message]
    end
  end
end
