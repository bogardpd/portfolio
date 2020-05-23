require "test_helper"

class ComputerFlowsTest < ActionDispatch::IntegrationTest
  
  def setup
    
  end

  # RESOURCE PAGES

  test "should get index" do
    get(computers_path)
    assert_response(:success)
  end

end