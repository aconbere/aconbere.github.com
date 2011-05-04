-module(mod_http_hello_world).
-author('Anders Conbere').
-vsn('1.0').

-define(EJABBERD_DEBUG, true).

-behaviour(gen_mod).

-export([
    start/2,
    stop/1,
    process/2
    ]).

-include("ejabberd.hrl").
-include("jlib.hrl").
-include("ejabberd_http.hrl").

start(_Host, _Opts) ->
    ok.

stop(_Host) ->
    ok.

process(_Path, _Request) ->
    "Hello World".
