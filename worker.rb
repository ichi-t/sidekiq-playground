require 'sidekiq'

Sidekiq.configure_client do |config|
  config.redis = { db: 1}
end

Sidekiq.configure_server do |config|
  config.redis = { db: 1 }
end

class OurWorker
  include Sidekiq::Worker
  sidekiq_options retry: 0

  def perform(complexity)
    case complexity
    when "super_hard"
      puts "Charging a credit card..."
      raise "Woops stuff got bad"
      puts "Really took quite a bit of effort"
    when "hard"
      sleep 10
      puts "That was a bit of work"
    else
      while true do
        sleep 1
        puts 'zomg bug'        
      end
    end
    puts "That wasn't a lot of effort"
  end
end
