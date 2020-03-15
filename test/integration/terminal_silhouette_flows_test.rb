require 'test_helper'

class TerminalSilhouetteFlowsTest < ActionDispatch::IntegrationTest
  
  def setup
    @silhouette = terminal_silhouettes(:ord)
  end

  # RESOURCE PAGES

  test "should get index" do
    get(terminal_silhouettes_path)
    assert_response(:success)
  end

  test "should redirect new when not logged in" do
    get(new_terminal_silhouette_path)
    assert_response(:redirect)
    assert_redirected_to(login_path)
  end

  test "should redirect create when not logged in" do
    post(terminal_silhouettes_path)
    assert_response(:redirect)
    assert_redirected_to(login_path)
  end

  test "should redirect edit when not logged in" do
    get(edit_terminal_silhouette_path(@silhouette))
    assert_response(:redirect)
    assert_redirected_to(login_path)
  end

  test "should redirect update when not logged in" do
    patch(terminal_silhouette_path(@silhouette))
    assert_response(:redirect)
    assert_redirected_to(login_path)
  end

  test "should redirect destroy when not logged in" do
    assert_no_difference("TerminalSilhouette.count") do
      delete(terminal_silhouette_path(@silhouette))
      assert_response(:redirect)
      assert_redirected_to(login_path)
    end
  end
  
  # REDIRECTS

  test "should redirect alternate terminal silhouette paths" do
    alternate_paths = %w(terminal-silhouettes terminal_silhouettes terminalsilhouettes terminals)

    alternate_paths.each do |alt_path|
      get("/#{alt_path}")
      assert_response(301)
      assert_redirected_to(terminal_silhouettes_path)
    end

  end

end
