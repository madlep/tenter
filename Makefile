all: compile

deps:
	rebar get-deps

compile: deps
	rebar compile

compile-debug: deps
	rebar -D debug compile

clean:
	rebar clean
	rm -Rf .eunit
