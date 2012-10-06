-module(tenter).
-author('madlep@madlep.com').

-include("tenter.hrl").

-export([
  create/2,
  discover/1
]).

create(Servers, Options) ->
  #tenter{servers=Servers, options=Options}.

discover(Url) ->
  tenter_discovery:discover(Url).

