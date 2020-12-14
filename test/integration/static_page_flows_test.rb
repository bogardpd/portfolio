require "test_helper"

class StaticPageFlowsTest < ActionDispatch::IntegrationTest

  def setup
   
  end
  
  test "should get home" do
    get(root_path)
    assert_response(:success)
  end

  test "should get certbot" do
    get("/.well-known/acme-challenge/0123456789abcdef")
    assert_response(:success)
  end

end
