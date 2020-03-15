require "test_helper"

class VlogVideoFlowsTest < ActionDispatch::IntegrationTest
  
  def setup
    @video = vlog_videos(:breakfast_stream_2019_01_01)
  end

  test "should get index" do
    get(vlog_videos_path)
    assert_response(:success)
  end

  test "should redirect new when not logged in" do
    get(new_vlog_video_path)
    assert_response(:redirect)
    assert_redirected_to(login_path)
  end

  test "should redirect create when not logged in" do
    post(vlog_videos_path)
    assert_response(:redirect)
    assert_redirected_to(login_path)
  end

  test "should redirect edit when not logged in" do
    get(edit_vlog_video_path(@video))
    assert_response(:redirect)
    assert_redirected_to(login_path)
  end

  test "should redirect update when not logged in" do
    patch(vlog_video_path(@video))
    assert_response(:redirect)
    assert_redirected_to(login_path)
  end

  test "should redirect destroy when not logged in" do
    assert_no_difference("VlogVideo.count") do
      delete(vlog_video_path(@video))
      assert_response(:redirect)
      assert_redirected_to(login_path)
    end
  end

end
