Nonterminals
links link params param.

Terminals
uri semicolon key eq value comma.

Rootsymbol
links.

links -> '$empty' : [].
links -> link : [ '$1' ].
links -> link comma links : [ '$1' | '$3' ].

link -> uri : [{uri, unwrap('$1') }, {params, []}].
link -> uri semicolon params : [{uri, unwrap('$1') }, {params, '$3'}].

params -> param : [ '$1' ].
params -> param semicolon params : [ '$1' | '$3' ].

param -> key eq value : { unwrap('$1'), unwrap('$3') }.

Erlang code.

unwrap({_,_,V}) -> V.
