-module(tenter_profile).
-author('madlep@madlep.com').

-include("tenter.hrl").

-export([
  build/2
]).

-define(INFO_BASIC, <<"https://tent.io/types/info/basic/v0.1.0">>).

build(json, ProfileJson) ->
  ParsedProfile = jiffy:decode(ProfileJson),
  {ok, Basic} = build_basic(ej:get({?INFO_BASIC}, ParsedProfile)),
  {ok, #post_profile{info_basic=Basic} }.

build_basic(ParsedBasic) ->
  AvatarUrl = ej:get({"avatar_url"}, ParsedBasic),
  Bio       = ej:get({"bio"}, ParsedBasic),
  {ok, Birthdate} = parse_birthdate(ej:get({"birthdate"}, ParsedBasic)),
  {ok, #info_basic{avatar_url = AvatarUrl, bio = Bio, birthdate = Birthdate} }.

% TODO extract this into birthdate module and test separately
parse_birthdate(Birthdate) when is_binary(Birthdate) ->
  BD = binary_to_list(Birthdate),
  DateStrings = string:tokens(BD, "-"),
  Dates = lists:map(
    fun(DateString) -> 
      {Date, []} = string:to_integer(DateString), Date
    end, DateStrings),
  parse_birthdate(Dates);
parse_birthdate([Year, Month, Day]) ->
  {ok, #birthdate{year=Year, month=Month, day=Day} };
parse_birthdate([Year, Month]) when Year >= 1000 ->
  {ok, #birthdate{year=Year, month=Month, day=undefined} };
parse_birthdate([Month, Day]) when Month =< 12 ->
  {ok, #birthdate{year=undefined, month=Month, day=Day} }.

