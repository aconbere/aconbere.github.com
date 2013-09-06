---
layout: post
title: Building Ejabberd Modules - Part 2 - Generic Modules
---

Continued from [Building Ejabberd Modules - Part 1 - Compiling Erlang]({% post_url 2008-07-16-building_ejabberd_modules_-_part_1_-_compiling_erlang %})

Ejabberd uses a plugin system based on Erlang modules. All Ejabberd Plugins implement the "gen_mod" behavior (or the gen_mod interface if not explicitly evoking the behavior). <a href="http://www.erlang.org/doc/design_principles/spec_proc.html">Behaviors</a> are simple methods within Erlang to protect an interface, which can be used (as is the case with many of the OTP behaviors) to encapsulate a certain set of functionality.

The gen_mod behavior required by all Ejabberd modules is exceptionally simple, and is defined in the <a href="http://www.process-one.net/en/wiki/ejabberd_module_development/">ejabbed module documentation</a>.

{% highlight erlang %}
start(Host, Opts) -> ok

stop(Host) -> ok

* Host = string()

* Opts = [{Name, Value}]

* Name = Value = string() 
{% endhighlight %}

Note: The module name must match the filename. (Thanks Damon!)

A sample ejabberd module would then look something like this:

{% highlight erlang %}
-module(my_module).

-author("Anders Conbere").

-behavior(gen_mod).

-include("ejabberd.hrl").
-export([start/2, stop/1]).
start(_Host, _Opt) -> ok.

stop(_Host) -> ok.
{% endhighlight %}

Most of the time however you'll be implementing a set of particular callbacks to match up with the requirements of internal processes. As an example when making HTTP modules, you'll need to export the process function which captures an HTTP request, and returns an HTTP response. The set of callbacks for a custom auth module are slightly more complex, but are still rather straight forward.

So with a little bit of editing we could turn the example above into a completely useless but installable module. To do that let's first edit the start function to output a debug message.

{% highlight erlang %}
start(_Host, _Opt) -> 
    ?DEBUG("EXAMPLE MODULE LOADING", []).
{% endhighlight %}

We'll now want to save and compile our file (let's call it mod_first_module.erl). To compile the module run this command.

{% highlight bash %}
$ erlc -I ~/path/to/ejabberd/src mod_first_module.erl
{% endhighlight %}

Or if you're running ejabberd trunk

{% highlight bash %}
$ erlc -I ~/path/to/ejabberd/include mod_first_module.erl
{% endhighlight %}

This will build the file mod_first_module.beam a byte-compiled Erlang file capable of being run on the Erlang beam interpreter. And finally we'll want to put this file on a path that can be sourced by ejabberd. For most people that will mean linking it into the ejabberd bin directory.

{% highlight bash %}
/var/lib/ejabberd/ebin $ ln -s /path/to/mod_first_module.beam
{% endhighlight %}

And last but not least you need to tell Ejabberd to start your module when it begins. So we'll edit the ejabberd.cfg file and add to the modules config

{% highlight erlang %}
{modules,
[
  {mod_adhoc,    []},
  ...
  {mod_first_module, []},% to send options to your module populate the [] list
  ...
]
}
{% endhighlight %}

now when we restart our ejabbed server (making sure that the loglevel is set to 5), we should see in the module loading phase.

> =INFO REPORT==== 2008-07-17 15:33:27 ===
> D(<0.37.0>:ejabberd_auth_my_auth:44) : EXAMPLE MODULE LOADING

And there you have it, pretty much the most basic ejabberd module you could possibly install.
