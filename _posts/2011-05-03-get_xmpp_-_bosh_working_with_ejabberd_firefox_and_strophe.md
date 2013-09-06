---
layout: post
title: BOSH working with Ejabberd, Firefox and Strophe
---

If you're planning on using XMPP as part of a communication tool in your website, flash application, or behind restricted firewalls... chances are that you're going to end up using BOSH.

BOSH (<a href="http://xmpp.org/extensions/xep-0124.html">Bidirectional-streams Over Synchronous HTTP</a>) is a Comet like protocol that provides a method for developers to use XMPP by way of HTTP in their applications. The trick is that HTTP doesn't really provide first class support for the tools needed to provide XMPP; HTTP is synchronous providing simple call and response methods versus XMPP's asynchronous event based protocol. The first attempts to overcome this used HTTP polling, in which every so often the client would ask the xmpp server "do I have any more messages". However with increasing demands for near realtime communication that time between requests decreases and as it does, polling begins to take a larger toll on web servers, both in terms of bandwidth and responsiveness.

To solve this protocols like Comet and BOSH have evolved. They work by making an http request with a long timeout (30 seconds for instance), when a new message arrives the server (finally) responds to the request. The client receives this new message and instantly initiates a new http request. This way the server almost always has a hanging HTTP request to respond to, and there are no extra http requests made beyond those that are needed.

> For more general information check out <a href="http://metajack.wordpress.com/2008/07/02/xmpp-is-better-with-bosh/">XMPP is better with BOSH</a>

Yesterday I set about getting my own test environment running for developing some BOSH related apps I'm working on. This turned out to be a bit of a struggle as I ran into a variety of issues that I had no idea about. The basics seem easy, install an xmpp server that supports BOSH, get a BOSH client, use it to write a test app and have at it. But there are some small details to get in the way. First is that not all web browsers support making XHR from local files (Firefox tells me this is a security issue), so you'll need to host your development files on a local webserver. Second is that unless you want to set up a crossdomain policy (not difficult) you'll need to have the BOSH server running on the same domain and port as your development files are being hosted. For most of us this means we'll need to set up some basic proxying.

To do this I used

* <a href="http://www.ejabberd.im/">EJabberdD</a>
* <a href="http://wiki.nginx.org/Main">NGinX</a>
* <a href="http://code.stanziq.com/strophe/">Strophe</a>

#### First

If you have the a version of Ejabberd later than 2.0 bosh support is enabled by default. To see if this is the case navigate to your local ejabberd instance <a href="http://localhost:5280/http-bind">http://localhost:5280/http-bind</a> if that isn't running then take a look at your ejabberd config.

There should be a section called "modules" near the bottom. If the module mod_http_bind isn't present, add it to the list of enabled modules. (as a quick warning if it's the <em>last</em> item in the list, you must not put a comma after it)

{% highlight erlang %}
{modules,
 [
    {mod_http_bind, []},
    ...
 ]}
 {% endhighlight %}

After that, check to make sure that http-bind is enabled in the ejabbed http server. It should look like this:

{% highlight erlang %}
{5280, ejabberd_http, [
         captcha,
         http_bind,
         http_poll,
         web_admin
        ]}
 {% endhighlight %}

now restart your ejabberd server.

{% highlight bash %}
> ejabberdctl restart
{% endhighlight %}

and try navigating to <a href="http://localhost:5280/http-bind">http://localhost:5280/http-bind</a>. If it is still not responding take a look at the ejabberd logs or try starting your ejabberd server in "live" mode <code>> ejabberdctl live</code>

#### Second:

Now that we have a running BOSH connection, we need it to be hosted at the same domain and port as our other web files. To do this we'll use the nginx proxy_pass directive (similar directives exist for apache). The server section of my nginx config looks like this.

{% highlight nginx %}
server {
    listen       80;
    server_name  localhost;

    location ~ ^/http-bind/ {       
        proxy_pass http://localhost:5280;
    }

    location / {
        root /var/www/development;
    }
}
{% endhighlight %}

This provides a proxy back to my running ejabberd server, and a web root to host my development files on.

#### Last:

With those two things set up, you can either, symlink or move your dev code into the nginx root established above. Point Strophe to <a href="http://localhost/http-bind/">http://localhost/http-bind</a> and everything should work.

#### Other Issues

There have been noted some issues with running strophe along side certain version of Firebug. If you are seeing empty responses from the server, this could be the case. You can side-step it by disabling the "Show XMLHttpRequests" console feature in the firebug console.
