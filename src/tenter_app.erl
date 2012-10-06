-module(tenter_app).
-author('madlep@madlep.com').

-behaviour(application).

-export([start/0, start/2, stop/1]).

% from http://stackoverflow.com/questions/10502783/erlang-how-to-load-applications-with-their-dependencies#10524644
start() -> a_start(tenter, permanent).

start(_Args, _Type) ->
  start().

stop(_State) ->
  ok.

a_start(App, Type) ->
    start_ok(App, Type, application:start(App, Type)).

start_ok(_App, _Type, ok) -> ok;
start_ok(_App, _Type, {error, {already_started, _App}}) -> ok;
start_ok(App, Type, {error, {not_started, Dep}}) ->
    ok = a_start(Dep, Type),
    a_start(App, Type);
start_ok(App, _Type, {error, Reason}) ->
    erlang:error({app_start_failed, App, Reason}).
