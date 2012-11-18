all: compile

deps:
	rebar get-deps

compile: deps
	rebar compile

compile-debug: deps
	rebar -D debug compile
eunit:
	rebar skip_deps=true eunit

clean:
	rebar clean
	rm -Rf .eunit
