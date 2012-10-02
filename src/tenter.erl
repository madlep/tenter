-module(tenter).
-author('madlep@madlep.com').

-include("tenter.hrl").

-export([
  create/2,
  discover/2
]).

create(Servers, Options) ->
  #tenter{servers=Servers, options=Options}.

discover(Tenter, Url) ->
  tenter_discovery:discover(Tenter, Url).

