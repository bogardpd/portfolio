require 'test_helper'

class TerminalSilhouetteFlowsTest < ActionDispatch::IntegrationTest
  
  test "should get terminal silhouettes" do
    get(terminal_silhouettes_path)
    assert_response(:success)
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
