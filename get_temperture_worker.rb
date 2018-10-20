require 'sidekiq'
require 'sidekiq-cron'
require 'nature_remo'

Sidekiq.configure_client do |config|
  config.redis = { db: 1 }
  # schedule_file = "config/schedule.yml"
  # if File.exists?(schedule_file)
  #   Sidekiq::Cron::Job.load_from_hash YAML.load_file(schedule_file)
  # end
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

Sidekiq::Cron::Job.create(name: 'Get Temp Worker - every minute',
                          cron: '* * * * *',
                          class: 'GetTempertureWorker'
                         )
