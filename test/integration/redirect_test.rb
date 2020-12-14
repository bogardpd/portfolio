# Tests routes that redirect to other sites.

require "test_helper"

class StaticPageFlowsTest < ActionDispatch::IntegrationTest

  def setup
  end

   ## Test redirects to paulbogard.net

   test "should redirect projects" do
    get "/projects"
    assert_response 301
    assert_redirected_to "https://paulbogard.net/projects/"
  
    get "/projects/tags/sample-tag"
    assert_response 301
    assert_redirected_to "https://paulbogard.net/projects/"
  end

  test "should redirect about" do
    get "/about"
    assert_response 301
    assert_redirected_to "https://paulbogard.net/"
  end

  test "should redirect airport code puns" do
    get "/airport-code-puns"
    assert_response 301
    assert_redirected_to "https://paulbogard.net/airport-code-puns/"
  end

  test "should redirect boarding pass parser" do
    get "/boarding-pass-parser"
    assert_response 301
    assert_redirected_to "https://paulbogard.net/boarding-pass-parser/"

    get "/projects/boarding-pass-parser"
    assert_response 301
    assert_redirected_to "https://paulbogard.net/boarding-pass-parser/"
  end

  test "should redirect CAD models" do
    get "/cad-models"
    assert_response 301
    assert_redirected_to "https://paulbogard.net/cad-models/"
  
    get "/projects/cad-models"
    assert_response 301
    assert_redirected_to "https://paulbogard.net/cad-models/"
  end

  test "should redirect computers and electronics pages" do
    pages = %w(
      /computers
      /computers/old
      /electronics
      /electronics/computers
      /electronics/computers/pancake
      /electronics/part-categories
      /electronics/part-categories/tablets      
    )
    pages.each do |page|
      get page
      assert_response 301
      assert_redirected_to "https://paulbogard.net/computers/"
    end
  end

  test "should redirect earthbound database" do
    get "/earthbound-database"
    assert_response 301
    assert_redirected_to "https://paulbogard.net/earthbound-database/"
    
    get "/projects/earthbound-database"
    assert_response 301
    assert_redirected_to "https://paulbogard.net/earthbound-database/"
  end

  test "should redirect fast track calculus" do
    get "/rhit/fast-track-calculus"
    assert_response 301
    assert_redirected_to "https://paulbogard.net/rhit/fast-track-calculus/"
  end

  test "should redirect flight directed graphs" do
    get "/projects/flight-directed-graphs"
    assert_response 301
    assert_redirected_to "https://paulbogard.net/flight-graphs/"
  end
  
  test "should redirect flight historian" do
    get "/flight-historian"
    assert_response 301
    assert_redirected_to "https://paulbogard.net/flight-historian/"
    
    get "/projects/flight-historian"
    assert_response 301
    assert_redirected_to "https://paulbogard.net/flight-historian/"
  end

  test "should redirect fred and harry" do
    get "/rhit/fast-track-calculus/fred-and-harry"
    assert_response 301
    assert_redirected_to "https://paulbogard.net/rhit/fred-and-harry/"
  end

  test "should redirect games" do
    get "/games"
    assert_response 301
    assert_redirected_to "https://paulbogard.net/games/"
  end

  test "should redirect gate 13" do
    get "/gate-13"
    assert_response 301
    assert_redirected_to "https://paulbogard.net/blog/20200118-unlucky-gate-13/"

    get "/projects/gate-13"
    assert_response 301
    assert_redirected_to "https://paulbogard.net/blog/20200118-unlucky-gate-13/"

    get "/projects/maps/gate-13"
    assert_response 301
    assert_redirected_to "https://paulbogard.net/blog/20200118-unlucky-gate-13/"
  end

  test "should redirect gps logging" do
    get "/gps-logging"
    assert_response 301
    assert_redirected_to "https://paulbogard.net/gps-logging/"
    
    get "/projects/gps-logging"
    assert_response 301
    assert_redirected_to "https://paulbogard.net/gps-logging/"
  end

  test "should redirect hotel pillow fort" do
    get "/hotel-pillow-fort"
    assert_response 301
    assert_redirected_to "https://paulbogard.net/hotel-pillow-fort/"
  end

  test "should redirect history" do
    get "/history"
    assert_response 301
    assert_redirected_to "https://paulbogard.net/personal-website-history/"
  end

  test "should redirect maps" do
    # Several map images link to pbogard.com/maps, so we need to make sure it
    # redirects appropriately.
    get "/maps"
    assert_response 301
    assert_redirected_to "https://paulbogard.net/maps/"
  end

  test "should redirect MCO lobby" do
    get "/mco-lobby"
    assert_response 301
    assert_redirected_to "https://paulbogard.net/mco-lobby/"
  end

  test "should redirect nights away and home" do
    get "/projects/nights-away-and-home"
    assert_response 301
    assert_redirected_to "https://paulbogard.net/blog/20200419-time-at-home-during-covid-19/"
  end

  test "should redirect oreo" do
    get "/oreo"
    assert_response 301
    assert_redirected_to "https://paulbogard.net/oreo/"
  end

  test "should redirect PAX" do
    get "/pax"
    assert_response 301
    assert_redirected_to "https://paulbogard.net/pax/"

    get "/pax/pax-prime-2010"
    assert_response 301
    assert_redirected_to "https://paulbogard.net/pax/"

    get "/pax/pax-prime-2010/1"
    assert_response 301
    assert_redirected_to "https://paulbogard.net/pax/"
  end

  test "should redirect resume" do
    get "/resume"
    assert_response 301
    assert_redirected_to "https://paulbogard.net/resume/"
  end

  test "should redirect RHIT" do
    get "/rhit"
    assert_response 301
    assert_redirected_to "https://paulbogard.net/rhit/"
  end
  
  test "should redirect shared itinerary" do
    get "/shared-itinerary"
    assert_response 301
    assert_redirected_to "https://paulbogard.net/shared-itinerary/"
    
    get "/projects/shared-itinerary"
    assert_response 301
    assert_redirected_to "https://paulbogard.net/shared-itinerary/"
  end

  test "should redirect song lyrics graph" do
    get "/projects/song-lyrics-graph"
    assert_response 301
    assert_redirected_to "https://paulbogard.net/blog/20200613-song-lyrics-graph/"
  end

  test "should redirect stephenvlog pages" do
    get "/stephenvlog"
    assert_response 301
    assert_redirected_to "https://paulbogard.net/stephenvlog/"

    get "/stephenvlog/tags/ohio"
    assert_response 301
    assert_redirected_to "https://paulbogard.net/stephenvlog/"

    get "/stephenvlog/days"
    assert_response 301
    assert_redirected_to "https://paulbogard.net/stephenvlog/days/"
    
    get "/stephenvlog/days/2019"
    assert_response 301
    assert_redirected_to "https://paulbogard.net/stephenvlog/days/"

    get "/stephenvlog/cheffcon-japan-2019"
    assert_response 301
    assert_redirected_to "https://paulbogard.net/stephenvlog/cheffcon-japan-2019/"

    get "/stephenvlog/location-project"
    assert_response 301
    assert_redirected_to "https://paulbogard.net/stephenvlog/location-project/"
  end

  test "should redirect terminal silhouettes" do
    get "/terminal-silhouettes"
    assert_response 301
    assert_redirected_to "https://paulbogard.net/terminal-silhouettes/"
    
    get "/projects/terminal-silhouettes"
    assert_response 301
    assert_redirected_to "https://paulbogard.net/terminal-silhouettes/"
  end

  test "should redirect time zone chart project page" do
    get "/projects/time-zone-chart"
    assert_response 301
    assert_redirected_to "https://paulbogard.net/time-zone-chart/"
  end

  test "should redirect time zone chart" do
    get "/timezones"
    assert_response 301
    assert_redirected_to "https://paulbogard.net/time-zones/"
  end

  test "should redirect turn signal counter" do
    get "/turn-signal-counter"
    assert_response 301
    assert_redirected_to "https://paulbogard.net/turn-signal-counter/"
    
    get "/projects/turn-signal-counter"
    assert_response 301
    assert_redirected_to "https://paulbogard.net/turn-signal-counter/"
  end

end