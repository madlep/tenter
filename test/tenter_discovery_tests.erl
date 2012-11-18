-module(tenter_discovery_tests).

-include_lib("eunit/include/eunit.hrl").

success_200_link_header_with_rel_tent_test() ->
  Success200 = {ok, "200", [{"Link", "<https://madlep.example.com/profile>; rel=\"https://tent.io/rels/profile\""}], []},
  {ok, ["https://madlep.example.com/profile"]} = tenter_discovery:fetch_profile(http_header, Success200).

success_200_link_header_with_multi_rel_tent_test() ->
  Success200 = {ok, "200", [{"Link", "<https://madlep.example.com/profile>; rel=\"https://tent.io/rels/profile\", <https://madlep.tent.example.com/profile>; rel=\"https://tent.io/rels/profile\""}], []},
  {ok, ["https://madlep.example.com/profile", "https://madlep.tent.example.com/profile"]} = tenter_discovery:fetch_profile(http_header, Success200).

success_200_link_header_with_non_rel_tent_test() ->
  Success200 = {ok, "200", [{"Link", "<https://madlep.example.com/profile>; rel=\"https://tent.io/rels/profile\", <https://madlep.something.example.com/profile>; rel=\"https://somethingelse.example.com\""}], []},
  {ok, ["https://madlep.example.com/profile"]} = tenter_discovery:fetch_profile(http_header, Success200).

success_200_link_header_with_no_rel_tent_test() ->
  Success200 = {ok, "200", [{"Link", "<https://madlep.something.example.com/profile>; rel=\"https://somethingelse.example.com\""}], []},
  {error, link_header_has_no_tent_rel} = tenter_discovery:fetch_profile(http_header, Success200).

success_200_link_header_with_garbage_test() ->
  Success200 = {ok, "200", [{"Link", "HAHA I SUCK AT HTTP"}], []},
  {error, couldnt_parse_link_header} = tenter_discovery:fetch_profile(http_header, Success200).

redirect_301_extracts_location_test() ->
  Redirect301 = {ok, "301", [{"Location", "http://example.com"}], []},
  {redirect, "http://example.com"} = tenter_discovery:fetch_profile(http_header, Redirect301).

redirect_302_extracts_location_test() ->
  Redirect302 = {ok, "302", [{"Location", "http://example.com"}], []},
  {redirect, "http://example.com"} = tenter_discovery:fetch_profile(http_header, Redirect302).

non_success_response_is_error_test() ->
  NotFound404 = {ok, "404", [], []},
  {error, non_success_http_response} = tenter_discovery:fetch_profile(http_header, NotFound404).
