require 'bundler/setup'
Bundler.setup

require 'zen-plaid'

# logger = Logger.new("/dev/null")
logger = Logger.new(STDOUT)
logger.level = Logger::INFO
Plaid.configure do |config|
  config.logger = logger
end
