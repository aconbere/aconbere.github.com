---
layout: post
title: Code Microformat Proposal
---

This has been published at least once to the best of my knowledge with very little follow up so for reference:

* [June 2005](http://microformats.org/discuss/mail/microformats-discuss/2005-June/000019.html)
* [July 2005](http://microformats.org/discuss/mail/microformats-discuss/2005-July/000115.html)

To bring this up again, I think that a compact microformat for dealing with blocks of code in (x)html could bring a lot to the development communities.  Not only would we be able to have a single standard format for embedding code examples in our webpages, but we could also store important and often times difficult to find data such as licenses, original authors, sets of authors, language, language version, etc.

## Examples##

### sites that make use of code blocks with metadata attached:

* [bigbold snippets](http://www.bigbold.com/snippets/)
* [phpbuilder.com](http://www.phpbuilder.com/snippet/)
* [code.djangoproject.com](http://code.djangoproject.com/)
* [phpclasses](http://www.phpclasses.org/browse/package/1702.html)

### Common metadata used:

* Author
* Author's Webpage
* Title of Package
* Description
* Language
* Language Version
* License

Typical use of code in these sites is either large text wrapped in <code>&lt;p&gt;</code> tags, or <code>&lt;pre&gt;</code> tags. With included text ranging anywhere from a few lines to a page or so.  Often times licenses and users are included in the code block as comments of that particular language, sometimes mentioned in the page, sometimes not mentioned at all.

## Schema

The hCode schema might consists of the following:

### hCode

* title. optional. text.
* description. optional text.
* author(s). required. Must use hCard.
* license(s). optional. text.
* language. required. text.
* language-version. optional. text.

## Field details

The fields of the hCode schema would represent the following

### fields

* hCode:: root class name
* title:: The class name title is used to designate the name of the name given to this block of code.
* description:: The class name description is used give a breif description of the function of the code.
* author:: Current contact info in a list of hCards.
* license:: rel="license" and link to the appropriate license.
* license-inline:: The class name license-inline is used to indicate a non-standard, or write a specific license inline.
* language:: the class name language is used to designate the the programming language code was written in.
* language-version:: the class name language-version is used to designate the version of the programming language used.

see <a href="http://microformats.org/wiki/code-examples">code-examples</a> and <a href="http://microformats.org/wiki/code-brainstorming">code-brainstorming</a> for further discussion.
