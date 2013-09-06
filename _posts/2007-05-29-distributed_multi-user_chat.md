---
layout: post
title: Distributed Multi-User Chat
---

Distributed Multi-User Chat (DMUC) is a problem that's been plaguing my mind for the last couple of weeks. It's an idea that built up after I began researching making an IRC client, which lead to me looking at XMPP which lead to me looking at how to properly distribute a multi user chat across a network.

### Benefits
The benefits are simple, scalability, redundancy, and security. As you build up a community on an IRC or XMPP MUC server there are theoretical limits to the bandwidth you can handle, the solution has always simply been to throw more machines at it (IRC handles this poorly, XMPP has better inter-server communication standards), and this isn't much of an issue given the content (text), if we were to expand the idea of a MUC to such data as video or voice, that kind of single point of contact will be brought to its knees.

With regards to redundancy there have been big wins for MUC in the past, in particular during times of strife in world at large (see the use of IRC by Iraqi Kurds during the attack on them by the Hussein regime). With a single point of failure (a single server) these kinds of uses are liable to be cut off from users at inopportune times by physical or network means.

For security since we are working in a distributed system we would need ways of effectively asserting identity. These kinds of problems have already been solved for us by way of SSL/PGP type protocols, using signed certs and distributed trust models we should be able to not only safely and quickly encrypt all data moving over the network, but effectively assert the identity and authenticity of all the data being brought to individual users.
