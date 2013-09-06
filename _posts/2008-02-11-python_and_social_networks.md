---
layout: post
title: Python and social networks
---

Those of you who don't know I've been working for <a href="http://fidgt.com">Fidgt</a> for the last couple of months. Mostly consulting on how best to integrate with the rest of the open social networking world, as well as how we can be the best participants possible. As part of this I've had the joy of being able to work with a number of the available python libraries for things like Microformats, FaceBook, and Flickr.

Sadly, very few of the available tools met our needs going forward, as such much of my time lately has been spent figuring out how to make a set of generic tools that will provide a basis for building up access to each of these services and their web service api's.

One of the first problems we had was that many of them either presumed a single user type solution (a class instantiated with a username and password), this is sub obtimal for our high load use case, and a bit difficult to work with when wanting to be able to generically query various social networks. The result is that the first thing I did was write an Auth layer. The auth layer is very simply a database access layer in sqlalchemy and some other associated functions to ease use. It stores the relation between a username that we use, a username that the remote service uses and a token or password for that user at that network. Since most of the authorization patterns use a very similar workflow for authorizing access from users this has let me abstract much of the background storage and retrieval of tokens.

So where are we on this? We currently have working libraries for FlickrAuth, and FacebookAuth and we're moving towards an OAuth solution.

Writing these libraries is when I began to really understand the beauty of oAuth. Ahhh... imagine only having to ever write one of these libraries and have it "just work" across multiple networks. And not only does oAuth solidify how we go about authorizing a user, but also defines the way we make signed requests to the service, so that i no longer have to write 5 different parameter serialization functions one for each service. It's a fantastic achievement, and my only beef is that it's flexibility lends itself to a much more complex set of tools to use it.
