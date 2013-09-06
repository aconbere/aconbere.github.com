---
layout: post
title: Problems With PHP
---

I've thought up a small list of things that bug me about PHP, things they could do better in future releases, things that they could adopt from other languages. When using PHP extensively you get a feeling of how it was designed, incrementally over a broad period of time without a particular vision or direction. This isn't irreparable, but it does make the language less enjoyable to code in.

## 1. Namespace collisions and include functions (see point 2 and 5)
When you go to include a PHP file into another one (because sometimes those files just get to be too big to mess with) if that file has within it function definitions or variables with the same name... it just overwrites them, is overwritten by them. There isn't as far as I can tell any namespace collision detection, and no way to import that file as a module in and of itself. That is, as an object from which everything within it could be referenced.

## 2. Not fully object oriented

This is something I've grown to love in dynamic languages, I love types being objects and the kind of common sense that comes with the methods attached to types. If I want to know how many times the letter "x" shows up in string "y" <code>y.count('x')</code> is beautiful.

## 3. Language consistency

A language should seek to be as standard with it's naming conventions as possible. Settle on one, camel case, or use underscores or '-'s, use verb noun, or noun verb. just pick one and stick with it!!

## 4. Large body of core functions

PHP feels a bit cluttered and just about anything seems to be able to get into it's core set of functions. Not everyone needs LDAP functions. why not just make a nice and simple LDAP module for those who need it, and let the rest of us be rid of it. Most likely this is a result of point 5.

## 5. Modularity not built in

PHP doesn't feel like anyone thought of modularity when it was being designed. Look at ruby or python for examples of this awesomeness. Sure it's got the pear repository, but even that's somewhat limited. I strongly believe that a good language should have a small definition (scheme is only just over 50 pages for the entire language) with it's power coming from modularity. That requires that new modules not stomp on namespaces, have an easy way to import them to an object, and an easy way to add or remove modules.
