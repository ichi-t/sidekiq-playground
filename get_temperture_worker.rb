require 'sidekiq'
require 'sidekiq-cron'
require 'nature_remo'
require './models/temp.rb'

Sidekiq.configure_client do |config|
  config.redis = { db: 1 }
end

Sidekiq.configure_server do |config|
  config.redis = { db: 1 }
end

class GetTempertureWorker
  include Sidekiq::Worker

  def perform
    p t = client.get_temp
    Temp.create(:timestamp => Time.now, :temperture => t)
  end

  private
  def client
    client ||= NatureRemo::Client.new
  end
end

Sidekiq::Cron::Job.create(name: 'Get Temp Worker - every minute',
                          cron: '* * * * *',
                          class: 'GetTempertureWorker'
                         )
