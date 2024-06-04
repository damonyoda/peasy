require 'sidekiq-scheduler'

module Health
  class Checker
    include Sidekiq::Worker

    def perform
        puts 'Hello world'
    end
  end
end