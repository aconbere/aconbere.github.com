---
layout: post
title: Portable Social Networks (XMPP)
---

I've been spending sometime thinking about one of my primary concerns with social networking tools today, the non-portability of the data you put into them. That is, you spend a great deal of time on any given social networking service discovering, and managing your social network, yet all the work that's done there is in general trapped on that service.

There are some services that have taken a more socially conscious attitude and allow you to export that data. From the look of <a href="http://www.leahculver.com/2007/09/03/portable-social-networks-for-django/">Leah Culvers blog</a> pownce (and by association probably digg) will be providing a service to manage your social graphs, <a href="http://geni.com">Geni</a> has a feature that allows you to export the family tree you've created and so on.

The solutions I've seen thus far are varied and there appears to be a lot of work going on in this space to come up with a solutions that works for service providers (facebook, myspace, pownce) as well as users of these services (my friends). Most of what I'm seeing is a kind of mashup of XFN, microformats, openID and scraping of sites. (The pownce solutions is actually a lot better than this in that it relies on a two way communication between the given services providing an actual api for the service to tie into). Other solutions have involved XML exports, or FOAF, but in the end all of these services rely on a static technology(XML) and a web service to manage the source of that XML document that services such as myspace and facebook could tie into.

I feel like these types of solutions are only stop gap measures for a type of problem that begs for a decentralized dynamic approach. The approach I've been taking is too take a look at what some of the other protocols available on the web already provide for us. In particular I think that most of what people are looking for in terms of a tool to collect and provide social graph data is cleverly handled by XMPP (jabber).

To better understand where I'm coming from here I want to lay out some of the basic problems we're trying to tackle with portable social networking. As I see them they are:

* a unique identification system: you have to have some way of uniquely identifying members of your social graph. This could be via openID or another uri type structure, or how email/xmpp does it with unique names per domain.
* a standardized format for defining relationships: XFN, FOAF, or just a list of friends will do. But people need to know what kind of data they're getting back. Looking at how most providers deal with friend data, the most important datum to know is who you recognize as being a "friend"
* a simple safe web api for requesting this data for use on other networks.

After one tackles those three primary problems the secondary problems are things like:

* The system should be distributed: This will allow for the easy use and scaling of the system.
* The system should be defined in a clear open standard: We don't want people to be tied to a particular language or implementation.

given that problem definition XMPP provides for nearly all of those and more. So how does it work?

We use XMPP's existing network, Jabber, to provide a decentralized set of servers for us to use. Each user on the jabber network has a unique id provided of the form xxx@domain.tld, authentication is over SASL and takes place in direct communication to the users jabber server from the client. The xmpp term for a social graph is a "roster" or buddy list. The roster provides a list of people with whom you have a trust relationship. By requesting a roster from an xmpp server you receive an xml file with a list of trusted users.

So, we as a social networking provider, ask for jabber authentication information at signup, those details are used to request a roster from their xmpp server, which we then use to form a starting social network on our service. Add a friend links or remove a friend links make a call to the xmpp server to remove or add the unique id's to and from their roster, this can either make direct calls to the webservice api or that can be done on the backend. In this way services are easily able to deploy their own xmpp gateway and yet any work done on their network is directly translated into changes in the jabber roster.

What excites me about this solution is that it actually gives something back to the network providers that they aren't getting now, for free. It gives them chat and presence! not only that but it allows users to manage their friend networks in the ways that they are comfortable with now, either through their current network providers (facebook, myspace), or through their im client, etc.
