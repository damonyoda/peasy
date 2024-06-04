class DailyRecordsController < ApplicationController

    def index
        @daily_records = DailyRecord.all

        template = File.read(Rails.root.join("app", "views", "daily_records/index.html.liquid"))

        render :inline => Liquid::Template.parse(template).render("daily_records" => @daily_records.map(&:attributes))
    end
end
