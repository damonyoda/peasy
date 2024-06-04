require "test_helper"

class DailyRecordsControllerTest < ActionController::TestCase
    fixtures :users, :daily_records

    test "should get index" do
        get :index
        assert_response :success
        assert_not_nil assigns(:daily_records)
    end

end
