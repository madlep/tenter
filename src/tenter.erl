-module(tenter).
-author('madlep@madlep.com').

-include("tenter.hrl").

-export([
  discover/1,
  start/1,
  get_profile/1
]).

create(Servers, Options) ->
  #tenter{servers=Servers, options=Options}.

discover(Url) ->
  tenter_discovery:discover(Url).

start(EntityUrls) ->
  tenter_http_client:start_link(EntityUrls).

get_profile(HttpClient) ->
  tenter_profile:get_profile(HttpClient).


