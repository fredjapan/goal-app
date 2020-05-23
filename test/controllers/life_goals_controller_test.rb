require 'test_helper'

class LifeGoalsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get life_goals_index_url
    assert_response :success
  end

end
