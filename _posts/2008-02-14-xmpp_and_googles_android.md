---
layout: post
title: XMPP and google's android
---

A post floated by the XMPP <a href="http://mail.jabber.org/mailman/listinfo/standards/">standards</a> mailing list today about a change to the <a href="http://code.google.com/android">android spec</a> involving their use of XMPP. The post is a scary statement from a company that has shown such willingness to work with the XMPP community to help build their Gtalk service.

> The com.google.android.xmppService package has been replaced by the com.google.android.gtalkservice package. This is driven by the fact that the GTalk API is not XMPP compliant, and will be less so going forward. The reason is that XMPP is too verbose and inefficient for mobile network connection, and the GTalk API will be moving to a binary encoding for the protocol between the client and the server.

This distresses me. Not because Google wants to do their own thing with their chat service, but because they feel like these are issues that either can't be remedied, or can't be brought to the xmpp community. The result of course is that the standards list has started a discussion about ways that the problem of network efficiency (on the mobile scale. For many standard uses XMPP is fantastically efficient) can be tackled.

<a href="https://stpeter.im/">Peter Saint-Andre</a> compiled a list of discussion points that could help with this.
* Recommendations regarding when to use the TCP binding and when to use the HTTP binding (BOSH).
* Compression via TLS or XEP-0138 (use it!). Also binary XML as a compression mechanism.
* Fast reconnect to avoid TLS+SASL+resource-binding packets.
* ETags for roster-get (see XEP-0150, let's resurrect that).
* Advisability of presence-only connections (no roster-get, just send presence and whatever you receive is nice).

Anyway I hope that Google recognizes the XMPP communities willingness to work with them to provide standard ways for them to accomplish these goals. Or that they should at least be having this discussion in the XMPP space so that other implementations of the protocol can interface or learn from them.

##Update:

There's been an <a href="http://groups.google.com/group/android-developers/msg/26ae3bf24372c2d4">update</a> on the developer google group for android clarifying part of what's going on here. It appears that Google had a particular subset of the functionality of a full messaging stack in mind when adding xmpp into android, and that to optimize that subset of functions they're employing a proprietary protocol.

So this might just be a case of over bad wording on their changes page, which has since percolated into the rest of the XMPP community. That being said there's something silly about implementing a non-standard solution for messaging on the device without consulting with the xmpp community and foundation on ways that you could make that standards compliant. And I think that if you look at what the "right thing" to do is (I'll quote Mark Atwood here)

> fix gtalk, not break android, and XMPP compression will beat their proprietary binary protocol

That being said, I think this is good wake up call to the XMPP community that this is a growing problem space, one that we need to think about and possibly one we should employee resources to tackle. And I think it would be very noble of google to work with the community in understanding the kinds of limitations their facing, the tools they need, and the ways that xmpp can help meet those needs.
