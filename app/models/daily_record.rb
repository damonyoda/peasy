class DailyRecord < ApplicationRecord
    before_save :calculate_average_age, if: -> { male_count_changed? || female_count_changed? }
  
    private
  
    def calculate_average_age
      total_male_age = User.where(gender: 'male').sum(:age)
      total_female_age = User.where(gender: 'female').sum(:age)
      
      if male_count.positive?
        self.male_avg_age = total_male_age.to_f / male_count
      else
        self.male_avg_age = 0
      end
      
      if female_count.positive?
        self.female_avg_age = total_female_age.to_f / female_count
      else
        self.female_avg_age = 0
      end
    end
  end
  