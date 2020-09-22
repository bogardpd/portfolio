require "test_helper"

class StaticPageFlowsTest < ActionDispatch::IntegrationTest

  def setup
   
  end
  
  test "should get home" do
    get(root_path)
    assert_response(:success)
  end

  test "should get projects" do
    get("/projects")
    assert_response(:success)
  end

  test "should get project tags" do
    Project.all_tags.each do |tag, value|
      get(projects_path(tag: tag))
      assert_response(:success)
    end
  end

  test "should get about" do
    get(about_path)
    assert_response(:success)
  end

  test "should get airport code puns" do
    get(airport_code_puns_path)
    assert_response(:success)
  end

  test "should get boarding pass parser" do
    get(boarding_pass_parser_path)
    assert_response(:success)
  end

  test "should get CAD models" do
    get(cad_models_path)
    assert_response(:success)
  end

  test "should get certbot" do
    get("/.well-known/acme-challenge/0123456789abcdef")
    assert_response(:success)
  end

  test "should get earthbound database" do
    get(earthbound_database_path)
    assert_response(:success)
  end

  test "should get fast track calculus" do
    get(fast_track_calculus_path)
    assert_response(:success)
  end

  test "should get flight directed graphs" do
    get(flight_directed_graphs_path)
    assert_response(:success)
  end

  test "should get flight historian" do
    get(flight_historian_path)
    assert_response(:success)
  end

  test "should get fred and harry" do
    get(fred_and_harry_path)
    assert_response(:success)
  end

  test "should get games" do
    get(games_path)
    assert_response(:success)
  end

  test "should get gate 13" do
    get(gate_13_path)
    assert_response(:success)
  end

  test "should get GPS logging" do
    get(gps_logging_path)
    assert_response(:success)
  end

  test "should get hotel pillow fort" do
    get(hotel_pillow_fort_path)
    assert_response(:success)
  end

  test "should get history" do
    get(history_path)
    assert_response(:success)
  end

  test "should get idea guy" do
    get(idea_guy_path)
    assert_response(:success)
  end

  test "should get MCO lobby" do
    get(mco_lobby_path)
    assert_response(:success)
  end

  test "should get nights away and home" do
    get(nights_away_and_home_path)
    assert_response(:success)
  end

  test "should get oreo" do
    get(oreo_path)
    assert_response(:success)
  end

  test "should get PAX" do
    galleries = {
      "pax-east-2013"   => 0,
      "pax-east-2014"   => 0,
      "pax-east-2015"   => 0,
      "pax-prime-2010"  => 3,
      "pax-prime-2011"  => 0,
      "pax-prime-2012"  => 0,
      "pax-prime-2013"  => 0,
      "pax-south-2019"  => 0,
      "pax-west-2017"   => 0,
      "pax-west-2018"   => 0,
    }    

    get(pax_path)
    assert_response(:success)

    galleries.each do |gallery, page_count|
      get(pax_gallery_path(gallery: gallery))
      assert_response(:success)

      if page_count > 0
        (1..page_count).each do |page|
          get(pax_gallery_path(gallery: gallery, page: page))
          assert_response(:success)
        end
      end
    end
  end

  test "should get resume" do
    get(resume_path)
    assert_response(:success)
  end

  test "should get RHIT" do
    get(rhit_path)
    assert_response(:success)
  end

  test "should get song lyrics graph" do
    get(song_lyrics_graph_path)
    assert_response(:success)
  end

  test "should get shared itinerary" do
    get(shared_itinerary_path)
    assert_response(:success)
  end

  test "should get starmen conventions" do
    galleries = {
      "applecon"              => 0,
      "camp-fangamer-2015"    => 0,
      "camp-fangamer-2018"    => 0,
      "camp-videogamely-2016" => 0,
      "chicagocon"            => 9,
      "flagstaff-con"         => 0,
      "gatlincon"             => 9,
      "indiana-minicon"       => 0,
      "utacon"                => 8,
      "washingcon"            => 11,
      "yes-we-con"            => 8,
    }    

    get(starmen_conventions_path)
    assert_response(:success)

    galleries.each do |gallery, page_count|
      get(starmen_con_gallery_path(gallery: gallery))
      assert_response(:success)

      if page_count > 0
        (1..page_count).each do |page|
          get(starmen_con_gallery_path(gallery: gallery, page: page))
          assert_response(:success)
        end
      end
    end
  end

  test "should get time zone chart" do
    get(time_zone_chart_path)
    assert_response(:success)
  end

  test "should get turn signal counter" do
    get(turn_signal_counter_path)
    assert_response(:success)
  end

  # REDIRECTS

  test "should redirect boarding pass parser" do
    get("/boarding-pass-parser")
    assert_response(301)
    assert_redirected_to(boarding_pass_parser_path)
  end

  test "should redirect CAD models" do
    get("/cad-models")
    assert_response(301)
    assert_redirected_to(cad_models_path)
  end

  test "should redirect computers" do
    get("/computers")
    assert_response(301)
    assert_redirected_to(electronics_root_path)
  end

  test "should redirect old computers" do
    get("/computers/old")
    assert_response(301)
    assert_redirected_to(electronics_root_path)
  end

  test "should redirect earthbound database" do
    get("/earthbound-database")
    assert_response(301)
    assert_redirected_to(earthbound_database_path)
  end

  test "should redirect flight historian" do
    get("/flight-historian")
    assert_response(301)
    assert_redirected_to(flight_historian_path)
  end

  test "should redirect gps logging" do
    get("/gps-logging")
    assert_response(301)
    assert_redirected_to(gps_logging_path)
  end
  
  test "should redirect maps" do
    # Several map images link to pbogard.com/maps, so we need to make sure it
    # redirects appropriately.
    get("/maps")
    assert_response(301)
    assert_redirected_to(projects_path(tag: :maps))
  end

  test "should redirect shared itinerary" do
    get("/shared-itinerary")
    assert_response(301)
    assert_redirected_to(shared_itinerary_path)
  end

  test "should redirect turn signal counter" do
    get("/turn-signal-counter")
    assert_response(301)
    assert_redirected_to(turn_signal_counter_path)
  end

end
