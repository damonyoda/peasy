require 'sidekiq-scheduler'

module DailyRecords
    class SaveToDatabase
        include Sidekiq::Worker

        def perform
            m_counter = Rails.cache.read("male:counter", raw: true).to_i
            f_counter = Rails.cache.read("female:counter", raw: true).to_i

            if m_counter > 0 
                m_average_age = User.where(gender: 'male').sum(:age) / m_counter
            end
            if f_counter > 0 
                f_average_age = User.where(gender: 'female').sum(:age) / f_counter
            end

            DailyRecord.create(
                date: Date.today, 
                male_count: m_counter, 
                female_count: f_counter, 
                male_avg_age: m_average_age,
                female_avg_age: f_average_age
            )

            Rails.cache.clear
        end
        
      
    end
end