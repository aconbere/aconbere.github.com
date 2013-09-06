---
layout: post
title: Announcing Babik
---

We use MPD here in my office to play media off of my machine. For some time we used a very nice client <a href="http://code.google.com/p/neompc/">NeoMPC</a>, however I recently moved machines and sticking with my goal of no longer writing any PHP I decided that it was time to change clients.  However I wasn't finding any nice Python or Ruby based web clients, so I wrote my own!

You can find <a href="http://code.google.com/p/babik/">Babik on google code</a>. There aren't any packaged releases, but feel free to grab the source.

It's all written in python, using the lovely py-libmpdclient2 as a back end along with <a href="http://www.djangoproject.com/">django</a>.  To install it on an existing django installation just drop in the source, add babik to your installed apps, and link the media to a static media server.
