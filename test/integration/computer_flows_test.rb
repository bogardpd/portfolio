require "test_helper"

class ComputerFlowsTest < ActionDispatch::IntegrationTest
  
  def setup
    @computer = computers(:fishsticks)    
  end

  # RESOURCE PAGES

  test "should get index" do
    get(computers_path)
    assert_response(:success)
  end

  test "should redirect new when not logged in" do
    get(new_computer_path)
    assert_response(:redirect)
    assert_redirected_to(login_path)
  end

  test "should redirect create when not logged in" do
    post(computers_path)
    assert_response(:redirect)
    assert_redirected_to(login_path)
  end

  test "should redirect edit when not logged in" do
    get(edit_computer_path(@computer))
    assert_response(:redirect)
    assert_redirected_to(login_path)
  end

  test "should redirect update when not logged in" do
    patch(computer_path(@computer))
    assert_response(:redirect)
    assert_redirected_to(login_path)
  end

  test "should redirect destroy when not logged in" do
    assert_no_difference("VlogVideo.count") do
      delete(computer_path(@computer))
      assert_response(:redirect)
      assert_redirected_to(login_path)
    end
  end

end