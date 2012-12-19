-record(tenter, {
  servers, 
  options
}).

-record(post_profile, {
  info_basic,
  info_core
}).

-record(info_basic, {
  avatar_url,
  bio,
  birthdate,
  gender,
  location,
  name,
  permissions,
  version
}).

-record(info_core, {
  entity,
  licenses,
  permissions,
  servers,
  tent_version,
  version
}).

