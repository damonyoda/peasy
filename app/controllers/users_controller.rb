class UsersController < ApplicationController
    skip_before_action :verify_authenticity_token, only: [:destroy]
    before_action :set_user, only: [:destroy]
  
    def index
        @users = User.all
        @users = @users.where("name->>'first' ILIKE :search OR name->>'last' ILIKE :search", search: "%#{params[:search]}%") if params[:search].present?

        template = File.read(Rails.root.join("app", "views", "users/index.html.liquid"))

        render :inline => Liquid::Template.parse(template).render('users' => @users.map(&:attributes))
    end
  
    def destroy
      @user.destroy
      # Update DailyRecord count
      update_daily_record_count(@user)
      render json: { message: "user has been removed successfully"}
    end
  
    private
  
    def set_user
      @user = User.find(params[:id])
    end
  
    def update_daily_record_count(user)
      daily_record = DailyRecord.find_by(date: user.created_at.to_date)
      if daily_record
        if user.gender == 'male'
          daily_record.update(male_count: daily_record.male_count - 1)
        elsif user.gender == 'female'
          daily_record.update(female_count: daily_record.female_count - 1)
        end
      end
    end
  end
  