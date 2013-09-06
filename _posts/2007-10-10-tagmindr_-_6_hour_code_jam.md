---
layout: post
title: Tagmindr - 6 hour code jam
---

Last Saturday I took part in an event called <a href="http://www.saturdayhouse.org/">SaturdayHouse</a> where a group of people get together at someone's house to collaborate, share ideas, think, read and in general share in the company of others. This Saturday a friend of mine <a href="http://briandorsey.info/">Brian Dorsey</a> of <a href="http://www.noonhat.com/lunch/">NoonHat</a> fame, suggested that we attempt to take that time to go from idea to production on a single idea, limiting ourselves to 6 hours.

The idea was simple, create a website that let people put in a username, have the app go crawl various sites looking for them and check what the tags are and if it has a tag "remind:YYYY-MM-DD" then remind them about that item when the date comes up. The Technology choices were made by Brian, we would be using Django (HURAH) the python web framework and Python. The result of this six hour code jam is <a href="http://tagmindr.com/">TagMindr</a>, "Put any bookmark in a time capsule and we'll send it to your future self.".

The way it works right now is it crawls your feeds on <a href="http://del.icio.us/">del.icio.us</a> and <a href="http://ma.gnolia.com/">magnolia</a> based on the tag "tagmindr" and then does a second search for any items with the tag "remind:YYYY-MM-DD". And it works! Also the design we came up with has proven to be quite flexible and adding in Magnolia and Flickr support only took a few minutes (so if you think of any other sites that allow tagging like this tell me!).

In all the event was fantastic, I met a ton of great people, and actually got to work with them on a project that is live right now. Discussion has continued and people are still committing changes to the svn repository. So I have high hopes for what can come of this, more events like it, more collaboration, more ideas brought to life.
