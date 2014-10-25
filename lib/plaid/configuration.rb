module Plaid
  class << self
    attr_accessor :configuration
  end

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.configure
    yield(configuration)
  end

  class Configuration
     attr_accessor :environment, :client_id, :secret

     def initialize
        @environment ||= ENV['PLAID_ENV']
        @client_id ||= ENV['PLAID_CLIENT_ID']
        @secret ||= ENV['PLAID_SECRET']
     end
  end
end
