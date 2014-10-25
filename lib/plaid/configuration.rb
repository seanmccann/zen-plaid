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
        @environment ||= ENV['PLAID_ENV'] || 'sandbox'
        @client_id ||= ENV['PLAID_CLASS_ID'] || 'test_id'
        @secret ||= ENV['PLAID_SECRET'] || 'test_secret'
     end
  end
end
