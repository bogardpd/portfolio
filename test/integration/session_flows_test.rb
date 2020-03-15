require "test_helper"

class SessionFlowsTest < ActionDispatch::IntegrationTest

  test "should get login" do
    get(login_path)
    assert_response(:success)
  end

end
