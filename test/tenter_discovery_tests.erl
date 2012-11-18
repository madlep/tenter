-module(tenter_discovery_tests).

-include_lib("eunit/include/eunit.hrl").

redirect_301_extracts_location_test() ->
  Redirect301 = {ok, "301", [{"Location", "http://example.com"}], []},
  {redirect, "http://example.com"} = tenter_discovery:fetch_profile(http_header, Redirect301).

redirect_302_extracts_location_test() ->
  Redirect302 = {ok, "302", [{"Location", "http://example.com"}], []},
  {redirect, "http://example.com"} = tenter_discovery:fetch_profile(http_header, Redirect302).
