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
     attr_accessor :environment, :client_id, :secret, :logger

     def initialize
        @environment ||= 'development'
        @client_id   ||= 'test_id'
        @secret      ||= 'test_secret'
        @logger      ||= Logger.new(STDOUT)
     end
  end
end
