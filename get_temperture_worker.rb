require 'sidekiq'
require 'sidekiq-cron'
require 'nature_remo'
require 'faraday'
require './models/temp.rb'



Sidekiq.configure_client do |config|
  config.redis = { url: 'redis://redis-server:6379' }
end

Sidekiq.configure_server do |config|
  config.redis = { url: 'redis://redis-server:6379' }
end

class GetTempertureWorker
  include Sidekiq::Worker

  def perform
    p t = client.get_temp
    p h = client.get_humi
    conn = Faraday.new(:url => 'https://gw.machinist.iij.jp') do |faraday|

      faraday.adapter Faraday.default_adapter
    end

    conn.post do |req|
      req.url '/endpoint'
      req.headers['Content-Type'] = 'application/json'
      req.headers['Authorization'] = "Bearer #{ENV['MACHINIST_TOKEN']}"
      req.body = "{
  \"agent\": \"Home\",
  \"metrics\": [
    {
      \"name\": \"temperature\",
      \"namespace\": \"Environment Sensor\",
      \"data_point\": {
        \"value\": #{t}
      }
    },
    {
      \"name\": \"humidity\",
      \"namespace\": \"Environment Sensor\",
      \"data_point\": {
        \"value\": #{h}
      }
    }
  ]
}"
    end
  end

  private
  def client
    client ||= NatureRemo::Client.new
  end
end

Sidekiq::Cron::Job.create(name: 'Get Temp Worker - every minute',
                          cron: '*/5 * * * *',
                          class: 'GetTempertureWorker'
                         )
