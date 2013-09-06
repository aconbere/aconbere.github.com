---
layout: post
title: Building Ejabberd Modules - Part 3 - HTTP Modules
---

<strong>Update</strong>: Now with a link to code! <a href="/media/code/mod_http_hello_world.erl">mod_http_hello_world</a><

Continued from <a href="http://anders.conbere.org/journal/building-ejabberd-modules-part-1-compiling-erlang/">Building Ejabberd Modules - Part 1 - Compiling Erlang</a> and <a href="http://anders.conbere.org/journal/building-ejabberd-modules-part-2-generic-modules/">Building Ejabberd Modules - Part 2 - Generic Modules</a>

One of the easy ways to get access to data hiding within ejabberd is to use an HTTP module. These modules are easy to write, and with a little bit of poking around ejabberd internals an easy way to get much of the data you want out. For our purposes today we'll be building an HTTP module to expose a JSON list of all the users currently logged into the server.

Before getting too complex we'll want to start with a simple example, simply being able to display something at a given URL. We'll begin by building off of the example from <a href="http://anders.conbere.org/journal/building-ejabberd-modules-part-2-generic-modules/">Part 2</a>, by creating a basic gen_mod template.

{% highlight erlang %}
-module(mod_http_hello_world).
-author('Anders Conbere').
-vsn('1.0').
-define(EJABBERD_DEBUG, true).
-behavior(gen_mod).
-export([
  start/2,
  stop/1,
  process/2
]).

-include("ejabberd.hrl").
-include("jlib.hrl").
-include("ejabberd_http.hrl").

start(_Host, _Opts) -> ok.
stop(_Host) -> ok.

process(_Path, _Request) -> "Hello World".
{% endhighlight %}

As you can see we've added the function process/2 from the example in part 2. Process/2 is the function that will handle HTTP calls, from the ejabberd HTTP server, the first argument of which is a list, which defines the path of the URL that will be handled. For example http://example.com/this/cool/article would be matched with process(["this", "cool", "article"], _Request), or if you wanted to capture data from the URL http://example.com/articles/puppies/2 (the second page of the puppies article) you can define process(["articles", Article, Page], _Request) which will result in the Article and Page variable being populated. For our purposes however we want the most simple definition, the catch all.

next you'll want to compile your new module

{% highlight bash %}
> erlc -I /var/lib/ejabberd/include -pa /path/to/ejabberd/src mod_http_hello_world.erl
> mv mod_http_hello_world.beam /var/lib/ejabberd/ebin
{% endhighlight %}

* note: the -I specifies an include path, necessary for finding .hrl files, the -pa adds a new look up path, necessary for finding gen_mod.erl
* note2: the current lib path for ejabberd is changing, in newer version, it can be found at /lib/ejabberd

Finally you'll want to configure ejabberd to start your module. So opening up ejabberd you're looking for the {listen, []} configuration, and then find the one for port 5280. This is currently the default port that ejabberd listens for HTTP requests on, and is used to serve the Admin tool. By default it should look something like this:


{% highlight erlang %}
{5280, ejabberd_http, [http_poll, web_admin]}
{% endhighlight %}

We'll be updating that to include our little module by making it look like this:

{% highlight erlang %}
{5280, ejabberd_http, [http_poll, web_admin, {request_handlers, [{["hello_world"], mod_http_hello_world} ]}]}
{% endhighlight %}

Which of course looks like a bunch of gobbelty gook. But what we've done is registered a new request handler, specified a root location to listen on (so in this case our module will respond on http://example.com:5280/hello_world) and specified a handler for that request. Restarting the server now, and opening that URL should return a page that says "Hello World".

That's all well and good, but it's not very interesting. We want to be able to get some useful data out of our system. So copy mod_http_hello_world.erl to mod_http_registered_users.erl and modify the -module() directive accordingly. And then we'll update the process() function. As is the trick with most things in ejabberd, this sort of stuff is easy once you know how. So as it turns out ejabberd_auth has a handy function dirty_get_registered_users/0 which returns a list of registered users on your server in the format [{username, server}], for those wondering I didn't just know about that function, I did a little bit of grepping around the source code to dig it up.
The only thing left to do is to reformat the data returned from dirty_get_registered_users and put it into your process function.

{% highlight erlang %}
process(_Path, _Request) ->
[Username ++ "@" ++ Server || {Username, Server} <- ejabberd_auth:dirty_get_registered_users()].
{% endhighlight %}

Finally we can repeat the steps of compiling the module and configuring it, and now you should be able to expose a list of users to the web (okay so maybe that's a bad idea). But more importantly these same techniques can be used to build REST api's for creating new users, building openID/oAuth endpoints, for creating interactive web pages that talk to ejabberd, and more.
