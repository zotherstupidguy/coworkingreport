require 'logger'
$logger = Logger.new(STDOUT)
#$logger.level = Logger::WARN

require './app'
run Sinatra::Application
