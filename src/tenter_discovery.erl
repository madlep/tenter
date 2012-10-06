-module(tenter_discovery).
-author('madlep@madlep.com').

-include("tenter.hrl").

-export([
  discover/1
]).

discover(Url) ->
  fetch_profile_urls(Url).
  % get profile URLs
    % make HEAD call to URL, capture 'Link' header value(s)
    % if not in header, GET URL, parse HTML, extract <link rel="tent..."> href values
  % get each profile URL with 'Accept: application/vnd.tent.v0+json' until one returns json ["https://tent.io/types/info/core/v0.1.0"]["servers"]
  % add profile URL and profile to tenter record

fetch_profile_urls(Url) ->
  maybe_from_html_head(maybe_from_header(Url)).

maybe_from_header(Url) ->
  extract_link_header(ibrowse:send_req(Url, [], head)).

% "<https://tent.titanous.com/profile>; rel=\"https://tent.io/rels/profile\", <https://titanous.tent.is/tent/profile>; rel=\"https://tent.io/rels/profile\", <https://tent.jonathan.cloudmir.com/profile>; rel=\"https://tent.io/rels/profile\""
extract_link_header({ok, "200", Headers, _Body}) ->
  extract_tent_rel_link(proplists:get_value("Link", Headers));
extract_link_header(_RequestFailed) ->
  not_in_headers.

extract_tent_rel_link(undefined) ->
  not_in_headers;
extract_tent_rel_link(_LinkHeader) ->
  foo.

maybe_from_html_head(not_in_headers) ->
  foo;
maybe_from_html_head(FoundUrlsInHeader) ->
  FoundUrlsInHeader.

