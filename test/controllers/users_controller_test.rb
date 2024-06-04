require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  setup do
    @user = users(:one) # Assuming you have fixture or factory data
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:users)
  end

  test "should filter users by name when search parameter is present" do
    get :index, params: { search: 'John' }
    assert_response :success
    assert assigns(:users).include?(@user)
  end

  test "should destroy user" do

    initial_daily_record = daily_records(:one)
    initial_daily_record.update(date: Date.today)

    assert_difference('User.count', -1) do
      delete :destroy, params: { id: @user.id }
    end

    assert_response :success
    json_response = JSON.parse(response.body)
    assert_equal "user has been removed successfully", json_response["message"]

    initial_daily_record.reload
    assert_equal 2, initial_daily_record.male_count, "male count should be 2 after 1 removed"
    assert_equal 1, initial_daily_record.female_count, "female count should be unchanged"
    assert_equal 35, initial_daily_record.male_avg_age, "male_avg_age should be updated to 35"
    assert_equal 20, initial_daily_record.female_avg_age, "female_avg_age should be unchanged"

    female_user = users(:two)
    assert_difference('User.count', -1) do
      delete :destroy, params: { id: female_user.id }
    end
    initial_daily_record.reload
    assert_equal 0, initial_daily_record.female_count, "female count should be 0"
    assert_equal 0, initial_daily_record.female_avg_age, "female_avg_age should be 0"
  end
end
