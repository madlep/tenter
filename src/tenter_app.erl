-module(tenter_app).
-author('madlep@madlep.com').

-behaviour(application).

-export([start/0, start/2, stop/1]).

% from http://stackoverflow.com/questions/10502783/erlang-how-to-load-applications-with-their-dependencies#10524644
start() -> 
  ensure_started(crypto),
  ensure_started(public_key),
  ensure_started(ssl),
  ensure_started(ibrowse).

start(_Args, _Type) ->
  start().

stop(_State) ->
  ok.

ensure_started(App) ->
  case application:start(App) of
    ok ->
      ok;
    {error, {already_started, App}} ->
      ok
  end.
