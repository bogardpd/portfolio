require "test_helper"

class ElectronicFlowsTest < ActionDispatch::IntegrationTest

  test "should get root" do
    get electronics_root_path
    assert_response :success
  end

end