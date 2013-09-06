---
layout: post
title: XMPP Roster Item Labels
---

I think that we've seen some fairly convincing examples of how labeling or tagging can reduce the complexity of grouping sets of data, in particular when it might be difficult to assign the data items into only on individual group. Some big uses of tagging as the primary form of grouping includes gmail, delicious, and flickr. However in XMPP our roster grouping are still relegated to binning or boxing (an item in a group exists in one and only one group). But roster items aren't simple data types, they represent our relationships with people! and people often don't belong to just one group. Rather the people in our lives often belong to many different intersecting groups (my good friend caleb, is both part of the programmers in my life, and my close friends, and my child hood friends, and the people I play soccer with, and climbing).  There doesn't seem to be an technical limitation in creating tags or labels for XMPP roster items, there are some questions to be answered about how to store the relations, and what semantics to use when querying them, but these aren't insurmountable.

as an initial reference for XEP's that look / act similar there is

* [MetaContacts](http://www.xmpp.org/extensions/xep-0209.html)
* [Annotations](http://www.xmpp.org/extensions/xep-0145.html)

My only worry is that both of these use the Storage protocol, and I question how easy it would be to form queries like 'retrieve me all the users with tags "X" and "Y"' Which might be out of band for this XEP but I suspect that queries like that might be powerful.
