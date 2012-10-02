-module(tenter_discovery).
-author('madlep@madlep.com').

-include("tenter.hrl").

-export([
  discover/2
]).

discover(Tenter, Url) ->
  todo.
  % get profile URLs
    % make HEAD call to URL, capture 'Link' header value(s)
    % if not in header, GET URL, parse HTML, extract <link rel="tent..."> href values
  % get each profile URL with 'Accept: application/vnd.tent.v0+json' until one returns json ["https://tent.io/types/info/core/v0.1.0"]["servers"]
  % add profile URL and profile to tenter record
