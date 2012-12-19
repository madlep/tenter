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
  AvatarUrl   = ej:get({"avatar_url"}, ParsedBasic),
  Bio         = ej:get({"bio"}, ParsedBasic),
  Birthdate   = ej:get({"birthdate"}, ParsedBasic),
  Gender      = ej:get({"gender"}, ParsedBasic),
  Location    = ej:get({"location"}, ParsedBasic),
  Name        = ej:get({"name"}, ParsedBasic),
  % TODO properly parse permissions
  {Permissions} = ej:get({"permissions"}, ParsedBasic),
  Version     = ej:get({"version"}, ParsedBasic),
  {ok, #info_basic{
    avatar_url  = AvatarUrl, 
    bio         = Bio, 
    birthdate   = Birthdate, 
    gender      = Gender,
    location    = Location,
    name        = Name,
    permissions = Permissions,
    version     = Version
  } }.


