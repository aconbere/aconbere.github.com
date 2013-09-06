---
layout: post
title: The First Road Block
---

As most people around me know, I've been working pretty hard on disseminating the idea of using jabber as a backbone for a truly open social network, as well as attempting to build a set of libraries exposing a simple web api to provide for this.

The two web frameworks I'm most comfortable with are Ruby on Rails and Django (and PHP but I'm not ready to back down that road just yet). So I've been moving forward building some simple web applications in these frameworks, and in general I'm calling the project <a href="http://code.google.com/p/xmpp-psn/">xmpp-psn</a> short for Extensible Messaging and Presence Protocol - Portable Social Network (I know that's a terrible marketing name, and a mouthful, but I'm focussed on building the tools more than thinking up good names, if you have suggestions... email me!).

Well, Friday talking to <a href="http://romeda.org/">Blaine Cook</a>, he brought up a point I had yet to consider and lends itself to a rather tricky problem. I've been writing these tools as if they were there only entry point to the app, of course this means that in order to scale the app you have to put it on better and better hardware, in particular it means given the way that most web servers work (spawning a new instance of the ruby/python interpreter through fastcgi or mod_*) that it can't run on any multiprocess or threaded web server.

So what's the solution?

I think for now I'm going to ignore it. There are solutions that exist <a href="http://chadfowler.com/ruby/drb.html">drb</a> or dynamic ruby offers a messaging type solution (much like how erlang deals with concurrency) a solution for messaging through apache sessions that I've forgotten the link to and more. The problem with all of these is that the would require a) a lot of restructuring of code I already have written, and b) a lot of time spent thinking about how to do it. So, considering how small my target audience is at the moment, and that I'm more concerned with showing people what can be done, I'm just going to let it slide. Hopefully someone will come along and help me work out that kink when activity picks up.
