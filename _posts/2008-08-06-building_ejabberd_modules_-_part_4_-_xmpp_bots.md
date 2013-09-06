---
layout: post
title: Building Ejabberd Modules - Part 4 - XMPP Bots
---

<strong>Update</strong>: Now with a link to code! <a href="/media/code/echo_bot.erl">echo_bot.erl</a></p>

Continued from <a href="http://anders.conbere.org/journal/building-ejabberd-modules-part-3-http-modules/">Building Ejabberd Modules - Part 3 - HTTP Modules</a>

So for this part we're going to step it up <em>a lot</em>, I was getting bored so here we are. I'm going to show you how to build a fast and efficient XMPP bot that lives in ejabberd. To be fair this bot is one part bot one part component and mostly tricky (thanks to the folks at RabbitMQ for giving me a lot of the ideas on how to do this). Since we don't want to get too crazy yet, we're going to build the most simple bot possible <b>Echo bot!</b>. This bot will simply message back to you everything you send it.

To discuss basic strategies, we're going to use the register_route function in ejabberd to build what is essentially a new virtual host. This will take all traffic heading to x.example.com and pass it through this module. Anyone who has written or looked at components in other languages should be familiar with this. This is the internal function used to register components.

Doing this gives us a lot of power that regular bots don't have. Component style bots aren't required to have rosters, don't have to deal with restrictions on identity, but they come at a cost. We'll be managing our own presence and subscription state, as well as a slew of other nigly details. That being said, the total comes out to 130 lines so it can't be that bad.

The first step will be to pull out our trusty tools from the previous articles. gen_mod and gen_server.

{% highlight erlang %}
-module(echo_bot).
-behavior(gen_server).
-behavior(gen_mod).

-export([start_link/2]).

-export([start/2,
         stop/1,
         init/1,
         handle_call/3,
         handle_cast/2,
         handle_info/2,
         terminate/2,
         code_change/3]).

-export([route/3]).

-include("ejabberd.hrl").
-include("jlib.hrl").

-define(PROCNAME, ejabberd_mod_bot).
-define(BOTNAME, echo_bot).
{% endhighlight %}

The only new part here is that we're going to expose one extra function "route/3" this is the function that will be passed to ejabberd to handle traffic coming to our bot. I also defined a couple of macros that will save us some headache later.

next we'll define the gen_server and gen_mod callbacks

{% highlight erlang %}
start_link(Host, Opts) ->
Proc = gen_mod:get_module_proc(Host, ?PROCNAME),
gen_server:start_link({local, Proc}, ?MODULE, [Host, Opts], []).

start(Host, Opts) ->
    Proc = gen_mod:get_module_proc(Host, ?PROCNAME),
    ChildSpec = {Proc,
        {?MODULE, start_link, [Host, Opts]},
        temporary,
        1000,
        worker,
        [?MODULE]},

    supervisor:start_child(ejabberd_sup, ChildSpec).

stop(Host) ->
    Proc = gen_mod:get_module_proc(Host, ?PROCNAME),
    gen_server:call(Proc, stop),
    supervisor:terminate_child(ejabberd_sup, Proc),
    supervisor:delete_child(ejabberd_sup, Proc).

init([Host, Opts]) ->
    ?DEBUG("ECHO_BOT: Starting echo_bot", []),
    % add a new virtual host / subdomain "echo".example.com
    MyHost = gen_mod:get_opt_host(Host, Opts, "echo.@HOST@"),
    ejabberd_router:register_route(MyHost, {apply, ?MODULE, route}),
    {ok, Host}.
{% endhighlight %}

So here's where I apologize to anyone who hasn't played with erlang/OTP before, cause there's some vodoo magic going on here. So let's take it slow.

<strong>start/2</strong> - we define a childspec. A childspec is the format of tupple that an OTP supervisor expects in order to start new children. What we're doing here is taking our bot and telling ejabberd to make sure that it stays up. After this stage even if our bot crashes, it will be restarted by ejabberd.

<strong>stop/1</strong> - we reverse the processes in start/1, we kill our prices and we remove it from supervision.

<strong>init/1</strong> - here we first create a new host (used for virtual hosting in ejabberd) this will be the domain that data passes through, so in this case "echo".yourdomain.com. Then we register a new route with ejabberd, giving it the host to route, and the function and module to call with each incoming packet.

We finish the callback with a bunch of boring. And then we go onto the meat of the problem. The routing.

{% highlight erlang %}
handle_call(stop, _From, Host) ->
    {stop, normal, ok, Host}.

handle_cast(_Msg, Host) ->
    {noreply, Host}.

handle_info(_Msg, Host) ->
    {noreply, Host}.

terminate(_Reason, Host) ->
    ejabberd_router:unregister_route(Host),
    ok.

code_change(_OldVsn, Host, _Extra) ->
    {ok, Host}.
{% endhighlight %}

Our first step is to handle presence and subscriptions. Since we don't really care to block anyone we'll completely skip the whole building a roster bit, and simply send back a "subscribed" response. And since we only want other clients to know we're online we are always available.

{% highlight erlang %}
route(From, To, {xmlelement, "presence", _, _} = Packet) ->
    case xml:get_tag_attr_s("type", Packet) of
        "subscribe" ->
            send_presence(To, From, "subscribe");

        "subscribed" ->
            send_presence(To, From, "subscribed"),
            send_presence(To, From, "");

        "unsubscribe" ->
            send_presence(To, From, "unsubscribed"),
            send_presence(To, From, "unsubscribe");

        "unsubscribed" ->
            send_presence(To, From, "unsubscribed");

        "" ->
            send_presence(To, From, "");

        "unavailable" ->
            ok;

        "probe" ->
            send_presence(To, From, "");

        _Other ->
            ?INFO_MSG("Other kind of presence~n~p", [Packet])

    end,
  ok;
{% endhighlight %}

So as far as routing goes, handling presence is pretty easy. As you can see we only use one helper function send_presence/3, and even that's very straight forward.

{% highlight erlang %}
send_presence(From, To, "") ->
    ejabberd_router:route(From, To, {xmlelement, "presence", [], []});

send_presence(From, To, TypeStr) ->
    ejabberd_router:route(From, To, {xmlelement, "presence", [{"type", TypeStr}], []}).
{% endhighlight %}

We reuse ejabberd routing tools to simply push presence elements back at the user as our bot. But simply handling presence wouldn't be very much fun, so we might also want to handle messages.

{% highlight erlang %}
route(From, To, {xmlelement, "message", _, _} = Packet) ->
    case xml:get_subtag_cdata(Packet, "body") of

    "" ->
        ok.

    Body ->
        case xml:get_tag_attr_s("type", Packet) of

        "error" ->
            ?ERROR_MSG("Received error message~n~p ->; ~p~n~p", [From, To, Packet]);
        _ ->
            echo(To, From, strip_bom(Body))
        end
    end,
    ok.

echo(From, To, Body) ->
    send_message(From, To, "chat", Body).

send_message(From, To, TypeStr, BodyStr) ->
    XmlBody = {xmlelement, "message",
           [{"type", TypeStr},
        {"from", jlib:jid_to_string(From)},
        {"to", jlib:jid_to_string(To)}],
           [{xmlelement, "body", [],
         [{xmlcdata, BodyStr}]}]},
    ejabberd_router:route(From, To, XmlBody).
{% endhighlight %}

To handle messages, we ignore all messages with empty bodies, raise errors on those that are error messages and call our function "echo" on those that don't meet those requirements. Where once again, echo simply takes advantage of ejabberd's route function and some simple xml construction.

we have one last helper function

{% highlight erlang %}
strip_bom([239,187,191|C]) ->; C;
  strip_bom(C) -&gt; C.
{% endhighlight %}

Which is used to strip the BOM or Byte Order Mark from the beginning of the body.

There we go, install the echo_bot just like the modules described in previous sessions. And you have a fast, lightweight, customizable xmpp bot. And hopefully in the next week I'll have a post that details how you can use that to make extremely powerful xmpp bots using tools like RabbitMQ.