-module(tenter_discovery).

-include("tenter.hrl").
-include("debug.hrl").

-export([
  discover/1,
  fetch_profile/2
]).

discover(Url) ->
  ?DEBUG("discovering via HEAD call to ~s~n", [Url]),
  case fetch_profile(http_header, ibrowse:send_req(Url, [], head))  of
    {ok, Profiles} ->
      Profiles;
    {redirect, RedirectUrl} ->
      discover(RedirectUrl);
    _Other ->
      fetch_profile(html_head_tag, Url)
  end.

fetch_profile(http_header, {ok, StatusCode, Headers, _Body}) 
  when StatusCode == "200"; 
       StatusCode == "301"; 
       StatusCode == "302" ->
  case StatusCode of
    "200" ->
      case extract_link_value(Headers) of
        undefined -> {error, link_header_not_present};
        LinkHeaderValue -> parse_link_value(LinkHeaderValue)
      end;
    "301" ->
      {redirect, proplists:get_value("Location", Headers)};
    "302" ->
      {redirect, proplists:get_value("Location", Headers)}
  end;

fetch_profile(http_header, _BadResponse) ->
  ?DEBUG("unsuccessful HEAD request : ~p~n", [_BadResponse]),
  {error, non_success_http_response};

fetch_profile(html_head_tag, _Url) ->
  {error, html_head_tag_discover_not_implemented}.

parse_link_value(LinkHeaderValue) ->
  case link_header_lexer:string(LinkHeaderValue) of
    {ok, LinkTokens, _EndLine} ->
      case link_header_parser:parse(LinkTokens) of
        {ok, Links} -> 
          filter_tent_rel_links(Links);
        _Error ->
          {error, couldnt_parse_link_header}
      end;
    _Error ->
      {error, couldnt_parse_link_header}
  end.

filter_tent_rel_links(Links) ->
  % [[{uri, "/profile"}, {params, [{"rel", "https://tent.io/rels/profile"}]}]]
  ProfileUrls = lists:foldl(
    fun(Link, Acc) -> 
        % [{uri, "/profile"}, {params, [{"rel", "https://tent.io/rels/profile"}]}]
        [{uri, ProfileUrl}, {params, Params}] = Link,
        case proplists:get_value("rel", Params) of
          "https://tent.io/rels/profile" -> 
            [ProfileUrl | Acc];
          _Other -> 
            Acc
        end
    end, [], Links),
  case ProfileUrls of
    [] -> {error, link_header_has_no_tent_rel};
    _Any -> {ok, lists:reverse(ProfileUrls)}
  end.

extract_link_value(Headers) ->
  case proplists:get_value("Link", Headers) of
    undefined -> proplists:get_value("link", Headers);
    LinkValue -> LinkValue
  end.

