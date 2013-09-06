---
layout: post
title: Building Ejabberd Modules - Part 1 - Compiling Erlang
---

These posts presume some basic familiarity with Erlang/OTP, if you're not familiar with them, this might be an interesting peak into how very simple systems built in erlang look and behave, but you might be best served by learning Erlang first. To do that I heartily recommend Joe Armstrong's book <a href="http://www.pragprog.com/titles/jaerlang/programming-erlang">Programming Erlang: Software for a Concurrent World</a>.

To start with the basics I should say something about what Ejabberd is and does. Ejabberd is an XMPP server written in erlang, designed for high availability with great hooks and plugins for extending the basic server. My first step into extending the behavior of Ejabberd begain with writing packet filters and has since had me mucking about in a few other places. Most recently I designed a custom authentication module for my friends at <a href="http://www.geni.com/">Geni</a>, and I wanted to talk a little about the process because I feel it illustrates some important concepts and tools to use when writing extension to Ejabberd.

So to start off you'll need to checkout and compile ejabberd on your own machine, as well as gather up an prerequisites that haven't been installed. In ubuntu you'll need to install build_essentials and possibly some other packages like libexpat.

{% highlight bash %}
$ svn co http://svn.process-one.net/ejabberd/trunk ejabberd
{% endhighlight %}

Then we'll want to enter into the src directory and run

{% highlight bash %}
$ ./configure
$ make
$ sudo make install
{% endhighlight %}

In OS X look out for libexpat not being on the search path (you can add it there by using ./configure --with-expat=/opt/local if you're using mac ports). This will install the ejabberdctl and ejabberd links into your /sbin directory as well as install the code into /var/lib/ejabberd, that will be important later for a quick shortcut to success.
