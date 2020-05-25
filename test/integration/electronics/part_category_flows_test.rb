require "test_helper"

class PartCategoryFlowsTest < ActionDispatch::IntegrationTest
  
  def setup
    @category = part_categories(:processors)
  end

  # RESOURCE PAGES

  test "should get index" do
    get electronics_part_categories_path
    assert_response :success
  end

  test "should redirect new when not logged in" do
    get new_electronics_part_category_path
    assert_response :redirect
    assert_redirected_to login_path
  end

  test "should redirect create when not logged in" do
    post electronics_part_categories_path
    assert_response :redirect
    assert_redirected_to login_path
  end

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
  #   assert_no_difference("PartCategory.count") do
  #     delete(electronics_computer_path(@computer))
  #     assert_response(:redirect)
  #     assert_redirected_to(login_path)
  #   end
  # end

end