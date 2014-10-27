require 'bundler/setup'
Bundler.setup

require 'zen-plaid'

logger = Logger.new("/dev/null")
logger.level = Logger::INFO
Plaid.configure do |config|
  config.logger = logger
end
