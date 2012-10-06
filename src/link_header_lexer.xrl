Definitions.

URIC  = [^<>]
KEYC  = [A-Za-z]
VALC  = [^"]
SC    = ;
EQ    = =
COM   = ,
WS    = ([\000-\s]|%.*)

Rules.

<({URIC})+> : {token, {uri, TokenLine, strip(TokenChars, TokenLen)}}.
{SC}        : {token, {semicolon, TokenLine, atom(TokenChars)}}.
{KEYC}+     : {token, {key, TokenLine, TokenChars}}.
{EQ}        : {token, {eq, TokenLine, atom(TokenChars)}}.
"({VALC})+" : {token, {value, TokenLine, strip(TokenChars, TokenLen)}}.
{COM}       : {token, {comma, TokenLine, atom(TokenChars)}}.
{WS}+       : skip_token.

Erlang code.

atom(TokenChars) -> list_to_atom(TokenChars).

strip(TokenChars,TokenLen) -> 
    lists:sublist(TokenChars, 2, TokenLen - 2).
