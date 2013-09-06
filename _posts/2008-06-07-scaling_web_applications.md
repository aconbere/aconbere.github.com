---
layout: post
title: Scaling web applications
---

I just got back from a fantastic excursion to LA where I met with <a href="http://romeda.org/">Blaine Cook</a> and Adam Pisoni (and others from <a href="http://geni.com">Geni</a> about a new product their releasing and how to use XMPP in that context and further how to scale it. This is pretty interesting to me because while I was brought in to talk about XMPP primarily, I've been dealing with scaling <a href="http://fidgt.com">Fidgt</a> the last month so all these problems are fresh in my mind. The whole two days of meeting flashed by, an unbelievable amount of diagramming, discussing, debating, arguing, and reworking went on with very little code (way cool). It got me thinking that maybe this is how healthy teams at healthy companies work and that maybe I should try that out sometime :-D

## Lessons:
* Yes massive queuing is the way to go.
* Aggregating results is far more costly than inserting data.
* Denormalization is a must.
* Memcache is near to god.
* There's something ugly and yet utilitarian about XMPP components (investigate further)
* BOSH/Comet are interesting tools for the hack that is AJAX, complicated plus and minuses
