require "test_helper"

class VlogVideoTagFlowsTest < ActionDispatch::IntegrationTest
  
  def setup
    @video_tag = vlog_video_tags(:breakfast_stream)
  end

  test "should get show" do
    get(show_vlog_video_tag_path(@video_tag.parameterized_name))
    assert_response(:success)
  end

  test "should redirect new when not logged in" do
    get(new_vlog_video_tag_path)
    assert_response(:redirect)
    assert_redirected_to(login_path)
  end

  test "should redirect create when not logged in" do
    post(vlog_video_tags_path)
    assert_response(:redirect)
    assert_redirected_to(login_path)
  end

  test "should redirect edit when not logged in" do
    get(edit_vlog_video_tag_path(@video_tag))
    assert_response(:redirect)
    assert_redirected_to(login_path)
  end

  test "should redirect update when not logged in" do
    patch(vlog_video_tag_path(@video_tag))
    assert_response(:redirect)
    assert_redirected_to(login_path)
  end

  test "should redirect destroy when not logged in" do
    assert_no_difference("VlogVideoTag.count") do
      delete(vlog_video_tag_path(@video_tag))
      assert_response(:redirect)
      assert_redirected_to(login_path)
    end
  end

end
