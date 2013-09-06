---
layout: post
title: Distribution Erlang and XMPP
---

These last few months I've found myself in an increasingly interesting position. The work I've been doing in XMPP has landed me in jobs I enjoy, building tools that are increasingly complex and more and more often, delve into the guts of what makes XMPP tick.

The end result has been spending most of the last half year doing some pretty serious programming in Erlang. From distributing python worker processes to ejabberd HTTP modules to do OpenId, route packets to databases, a memcached client, and custom auth modules.

There's been a lot of talk about Erlang lately, some of it has been good some of it's been bad, and a lot of it's been stupid. I'm not going to pretend to know everything about all the different concurrency systems, or the granular differences between scala, Erlang, gambit scheme.

I know that I've always had difficulty with the Java platform (This is a personal failing that maybe in the coming years I can fix), I can't keep track of what version I need (J2EE, JRE, JDK, SDK, JKMLZ-what?), and things never seem to work like I expect. So that left <a href="http://www.scala-lang.org/">scala</a> out, not to mention a number of <a href="http://steve.vinoski.net/blog/2008/05/18/clearly-time-to-end-this/">much</a> <a href="http://patricklogan.blogspot.com/2008/05/this-is-part-two-of-my-response-to-ted.html">smarter</a> people than I am have expressed some concerns about the purity of the concurrency model in scala. It seems that the biggest argument in favor of solutions on the JVM is the large sets of libraries available for it, which is probably reasonable give some of my issues trying to get Erlangs gd library to work, but seems to be much less of an issue depending on the domain you're working in.

I also know that I've spent a lot of time programming python, and I love python for what it does, but <a href="http://twistedmatrix.com/trac/">twisted</a> is devil spawn. It's not the callback style programing that bothers me, or the great deferred object, it's all the other crap that's been piled in. It's the lack of python style, and the way it inches it's way into the rest of the code using it, and turns it into unreadable mush. I much prefer the model that <a href="http://kamaelia.sourceforge.net/Home">Kamaelia</a> has chosen which is actually quite similar to the message passing style of Erlang.

Unfortunately... both of these python solutions are still single threaded, don't have great support to go across machines or networks, and provide none of the tools that Erlang/otp do for managing systems of multiple processes (like apps and supervisors).

Now Erlang is not without it's warts, I do have to spend some time fixing syntax errors from time to time, it could probably do with better library support (in particular with database drivers since this is actually in its domain space). OTP is really complex, and learning how all the pieces work and fit together is taxing, hard, and at least for me bent my mind. And lastly I find that immutable variables reduces some of the easy code-reuse you can do in ruby or python. But even these have caveats, the syntax might be overly verbose and require line endings, but it's very consistent and can be picked up quickly especially for anyone who has done any functional programming. OTP might be complex and difficult to learn initially, but the functionality that it provides is amazing, the applications fit together smoothly, and they 'Just work', it's truly an incredible piece of engineering. And lastly code-reuse, I don't have a could answer for this, but I suspect it has to do with meta-programming.

So I'm hoping to have some time in the next couple weeks to write a couple little pieces about how to make some new modules for ejabberd and use Erlang to make the best of it.
