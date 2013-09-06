---
layout: post
title: GameWrangle - 6 hour startup
---

Last Saturday we did another 6 hour startup, this time the goal was to create a game trading site that used the xmpp as the backend for storing data about who you're friends are. This was probably a little too ambitious and the result is at gamewrangle.com. We had a distinct lack of designers present and it shows. That being said we actually accomplished a good deal of work, I think everyone was pretty pumped about the project and it "works".

The basic idea is pretty simple.

* you're a gamer, you have games you don't play anymore, there are games you haven't played and want to.
* you have friends who are gamers as well in the same situation.
* these friends are in your messenger buddy list
* by alerting you to the existence of who has and wants what, we can facilitate trading games between you and your friends.

The mechanism is simple, just add a list of the games you are willing to trade, and a list of games you want, and we go and find the "matches". The business plan involves using the rich data from game entry to display targeted advertising or amazon referral links.

I learned a couple of key things, mostly regarding the use of my own jabber libraries, and how important it will be to get the jabber devs to understand how powerful an authorization workflow would be.
