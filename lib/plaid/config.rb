module Plaid
  module Configure
    attr_writer :client_id, :secret

    KEYS = [:client_id, :secret]

    def config
      yield self
      self
    end

  end
end
