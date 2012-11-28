-module(tenter_http_client).
-behaviour(gen_server).
-author('madlep@madlep.com').

-include("tenter.hrl").
-include("debug.hrl").

-export([start_link/1]).
-export([http/3]).
-export([init/1, handle_call/3, code_change/3, handle_cast/2, handle_info/2, terminate/2]).

start_link(EntityUrls) ->
  gen_server:start_link(tenter_http_client, EntityUrls, []).

http(HttpClient, Method, Path) ->
  gen_server:call(HttpClient, {http, Method, Path}).

init(EntityUrls) ->
  {ok, EntityUrls}.

handle_call({http, HttpMethod, Path}, _From, EntityUrls) ->
  Http = fun(Url, not_found_yet) ->
      ?DEBUG("making HTTP ~p call to ~s", [HttpMethod, Url ++ Path]),
      case ibrowse:send_req(Url ++ Path, [], HttpMethod) of 
        {ok, StatusCodeStr, _Headers, Body} -> 
          {StatusCode, []} = string:to_integer(StatusCodeStr),
          check_received(StatusCode, Body);
        _Other ->
          not_found_yet
      end;
    (_Url, ResponseBody) ->
      ResponseBody
    end,
  ResponseBody = lists:foldl(Http, not_found_yet, EntityUrls),
  {reply, ResponseBody, EntityUrls}.

check_received(StatusCode, Body) when StatusCode >= 200, StatusCode < 300 ->
  Body;
check_received(StatusCode, Body) when StatusCode >= 400, StatusCode < 500 ->
  Body;
check_received(_StatusCode, _Body) ->
  not_found_yet.

code_change(_OldVsn, _State, _Extra) -> 
  ?DEBUG("code_change", []),
  {error, not_implemented}.

handle_cast(_Request, _State) -> 
  ?DEBUG("handle_cast", []),
  {error, not_implemented}.

handle_info(_Info, _State) -> 
  ?DEBUG("handle_info", []),
  {error, not_implemented}.

terminate(_Reason, _State) -> 
  ?DEBUG("terminate", []),
  {error, not_implemented}.
