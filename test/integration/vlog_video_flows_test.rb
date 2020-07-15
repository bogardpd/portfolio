require "test_helper"

class VlogVideoFlowsTest < ActionDispatch::IntegrationTest
  
  def setup
    @video = vlog_videos(:breakfast_stream_2019_01_01)
  end

  # STATIC PAGES

  test "should get days" do
    get(show_vlog_days_path)
    assert_response(:success)

    get(show_vlog_days_path(year: 2019))
    assert_response(:success)
  end

  test "should get cheffcon japan" do
    get(cheffcon_japan_2019_path)
    assert_response(:success)
  end

  test "should get stephenvlog location project" do
    get(stephenvlog_location_project_path)
    assert_response(:success)
  end

  # RESOURCE PAGES

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
