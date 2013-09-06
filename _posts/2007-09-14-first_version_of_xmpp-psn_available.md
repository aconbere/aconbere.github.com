---
layout: post
title: First Version of Xmpp-PSN available
---

Today I finished the first version of a Django app that lets you build a social networking site on top of Jabber (XMPP). You can find out more about the basics of the project <a href="http://anders.conbere.org/journal/post/portable-social-networks-xmpp/">here</a>, but basically it's an http layer on top of a common python XMPP library that lets you do most of the roster management available through XMPP by way of a simple restful api.

The workflow for using it is simple, just install the app into an existing django project, and that will expose the api. From there you can post your jid and password to the /login/ url which returns a uuid and a roster in JSON format for your web app to digest. (note: this is horrible security practice, don't do this in the wild) Now that you have a uuid you have access to the rest of the api, which links to a thread on the sever that keep track of your jabber session.

the following is a list of the supported roster functions:

* disconnect
* roster
* subscribe
* unsubscribe
* authorize
* unauthorize
* remove
* login
