require 'sidekiq'
require 'nature_remo'

Sidekiq.configure_client do |config|
  config.redis = { db: 1 }
end

Sidekiq.configure_server do |config|
  config.redis = { db: 1 }
end

class GetTempertureWorker
  include Sidekiq::Worker

  def perform
    p client.get_temp
  end

  private
  def client
    client ||= NatureRemo::Client.new
  end

end
