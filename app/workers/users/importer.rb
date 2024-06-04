require 'sidekiq-scheduler'
require 'uri'
require 'net/http'

module Users
    class Importer
        include Sidekiq::Worker

        def perform
            uri = URI('https://randomuser.me/api/?results=20')
            response = Net::HTTP.get_response(uri)
        
            if response.is_a?(Net::HTTPSuccess)
                data = JSON.parse(response.body)
                process_user_data(data['results'])
            else
                puts "Failed to fetch data from the API. Status code: #{response.code}"
            end
        end
        
        def process_user_data(users_data)
            m_count = 0
            f_count = 0
            
            users_data.each do |user_data|
                user_uuid = user_data.dig('login', 'uuid')
                user = User.find_or_initialize_by(uuid: user_uuid)
                
                user.gender = user_data['gender']            
                user.name = user_data['name']
                user.location = user_data['location']
                user.age = user_data.dig('dob', 'age')

                if user.new_record?
                    user.gender == 'male' ? m_count += 1 : f_count += 1
                end
            
                user.save!
            end
        
            update_gender_counters(m_count, f_count)
        end
        
        def update_gender_counters(male_count, female_count)
            m_total = Rails.cache.increment('male:counter', male_count, initial: 0)
            f_total = Rails.cache.increment('female:counter', female_count, initial: 0)
            puts "Updated gender counters: Male: #{m_total}, Female: #{f_total}"
        end
      
    end
end