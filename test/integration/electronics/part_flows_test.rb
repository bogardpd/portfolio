require "test_helper"

class PartFlowsTest < ActionDispatch::IntegrationTest
  
  def setup
    
  end

  # RESOURCE PAGES

  test "should get index" do
    get(electronics_parts_path)
    assert_response(:success)
  end

  # test "should redirect new when not logged in" do
  #   get(new_electronics_computer_path)
  #   assert_response(:redirect)
  #   assert_redirected_to(login_path)
  # end

  # test "should redirect create when not logged in" do
  #   post(electronics_computers_path)
  #   assert_response(:redirect)
  #   assert_redirected_to(login_path)
  # end

  # test "should redirect edit when not logged in" do
  #   get(edit_electronics_computer_path(@computer))
  #   assert_response(:redirect)
  #   assert_redirected_to(login_path)
  # end

  # test "should redirect update when not logged in" do
  #   patch(electronics_computer_path(@computer))
  #   assert_response(:redirect)
  #   assert_redirected_to(login_path)
  # end

  # test "should redirect destroy when not logged in" do
  #   assert_no_difference("VlogVideo.count") do
  #     delete(electronics_computer_path(@computer))
  #     assert_response(:redirect)
  #     assert_redirected_to(login_path)
  #   end
  # end

end