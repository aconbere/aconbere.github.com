---
layout: post
title: Python Microformats Parser
---

I've just finished most of the work on a new python microformat parser. For the most part what it does is quite simple. It uses lxml and their html parser to pull an html block into memory, transforming it into valid xml, then uses brian suda's great xsl transforms to convert that into valid vCard and vCalendar items which are parsed by vObject.

Surprisingly this all works pretty well, and is actually quite fast. That being said it suffers from a few problems. The vCard implementation doesn't seem to support multiple typed data well (the interface to get that back out is cludgy), and the hAtom xsl document I'm using seems to return empty strings.

So right now I'm claiming really quite good support for vCard and cCalendar, near support for hAtom, as well as including a parser for xfn, and rel="tag".

The main draw back to this glue type method is that I'm not providing a consistent object interface, though in time I imagine I could clean that up. Overall it's support for the full range of vCard and vCalendar attributes is much better than that of the previous python parser, and it's chances of being easily extendable are high (all we would need to do is write new xsl documents).
