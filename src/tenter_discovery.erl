-module(tenter_discovery).
-author('madlep@madlep.com').

-include("tenter.hrl").

-export([
  discover/1
]).

discover(Url) ->
  case fetch_profile(http_header, Url)  of
    {ok, Profiles} ->
      Profiles;
    Other ->
      io:fwrite("couldn't fetch profile URL via HTTP header ~w~n", [Other]),
      fetch_profile(html_head_tag, Url)
  end.

fetch_profile(http_header, Url) ->
  case ibrowse:send_req(Url, [], head) of
    {ok, StatusCode, Headers, _Body} ->
      case StatusCode of
        "200" ->
          case extract_link_value(Headers) of
            undefined -> {error, link_header_not_present};
            LinkHeaderValue -> parse_link_value(LinkHeaderValue)
          end;
        "301" ->
          fetch_profile(http_header, proplists:get_value("Location", Headers));
        "302" ->
          fetch_profile(http_header, proplists:get_value("Location", Headers))
      end;
    BadResponse ->
      io:format("unsuccessful HEAD request to ~s : ~p~n", [Url, BadResponse]),
      {error, non_success_http_response}
  end;

fetch_profile(html_head_tag, _Url) ->
  "foo".

parse_link_value(LinkHeaderValue) ->
  {ok, LinkTokens, _EndLine} = link_header_lexer:string(LinkHeaderValue),
  {ok, Links} = link_header_parser:parse(LinkTokens),

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
  {ok, lists:reverse(ProfileUrls)}.

extract_link_value(Headers) ->
  case proplists:get_value("Link", Headers) of
    undefined -> proplists:get_value("link", Headers);
    LinkValue -> LinkValue
  end.
