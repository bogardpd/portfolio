require "test_helper"

class TimeZoneFlowsTest < ActionDispatch::IntegrationTest
  
  test "should get time zones" do
    get(timezones_path)
    assert_response(:success)
  end

end
