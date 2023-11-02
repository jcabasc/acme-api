# frozen_string_literal: true

require 'redis'

## Added rescue condition if Redis connection is failed
PORT = 6379

begin
  $redis = Redis.new(:host => Rails.configuration.redis_host, :port => PORT)
rescue Exception => e
  puts e
end
