-module(tenter_profile).

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
  {ok, #info_basic{avatar_url = AvatarUrl, bio = Bio, birthdate = Birthdate} }.


