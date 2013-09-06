---
layout: post
title: Atom feeds for igor... difficult
---

The first problem was actually reading the atom specs which I had neglected to do. Most of my previous work with atom had been in either creating elements used in various locations (Google data is all passed as Atom elements, as well as moments of injecting atom elements into xmpp streams). So I cobbled together what I thought was a decent first attempt at a Jinja template for building the atom file, published it and redirected my browser there... only to see nothing.

The XML was being generated, but not parsed.

The problems left were:

* writing out dates in RFC:3339 format
* building correct id's for elements

for RFC 3339 I found a <a href="http://henry.precheur.org/projects/rfc3339.html">nice python library</a> in the public domain for producing the correct format from a datetime object. To you <a href="http://henry.precheur.org/">Henry Precheur</a> I am quite grateful.

Generating correct id's was a little more tricky. First I tried generating uuid's but upon reading Mark Pilgrims post on <a href="http://diveintomark.org/archives/2004/05/28/howto-atom-id">atom element id's</a> I ended up writing a small function to generate tag: urns based on the time when a post was published (I'm not sure this is a /good/ solution given that I'm working with version control systems and you might legitimately have many articles published at the same time).

In the end I'm fairly content with the result, it required a morning's effort, more time than I had wanted to devote to atom publishing, but still successful.
