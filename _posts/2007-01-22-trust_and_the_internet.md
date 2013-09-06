---
layout: post
title: Trust and the Internet
---

Trust has always been an issue for the Internet, or at least for as long as I've been using it. There was probably a period of time during the <a href="http://en.wikipedia.org/wiki/Arpanet">arpanet</a> expansion where trust wasn't an issue, but during that time it might have been possible to know personally all the users. Today the situation is a little different. Today trust is a huge issue, spam, phishing, viruses, spyware/adware/malware, have brought trust to the public eye, and yet it's clearly still an issue as people continue to bring their computers to me to be fixed saying things like "there's too much junk on it", or "I think I have a virus", or "it just stopped working". Nearly 100% of these cases are problems of trust.

Many people point to the problem of viruses and spyware and will arrive at one of the following conclusions

1. it's the users fault, they should have been more careful / know better / been better educated. 
2. it's the operating systems fault, it shouldn't be this easy to be infected
3. it's those nasty villains who write the junk, there's too many of them, margins are too high, we'll never be able to stop them. (if you think of another common reason drop me a line).

Some of this I think is based on reasonable foundations. Yes this problem would be mitigated if users were better educated about the dangers of the Internet and proper administration techniques. Yes this problem would be mitigated if some operating systems made if a necessity or at least convenient to run as a restricted user. Yes this problem would be mitigated if there wasn't greed and sociopathy in the world.

Now recognizing that it will take years to decades to educate people about how computers work, and the risks involved installing software from random websites, and how important it is to do regular updates (and my never happen at all). That even though Windows Vista is coming out and it makes great strides in making limited user accounts usable, Windows XP will still be in wide circulation for many more years to come, and a lot of people aren't very confident in Microsoft to provide a truly secure operating system. And finally given that we will never rid the world of greed and creeps. Then how do we approach this problem, and what are the fundamentals of solving it.

I believe the answer lies in trust.

The problem is that in the modern computing environment (and I believe this is true of all major operating systems on the market today) The user requires or desires specialization beyond what is made available by default. There really isn't that much you can do with an average default installation these days. The Internet has helped to mitigated this problem by providing this huge wealth of software to trial, run for free, buy available at your fingertips. Now users can get almost anything they would want with a quick Google search. And here in lies the problem. How does an everyday consumer gather enough domain knowledge about services found through a Google search to accurately deduce whether the source is trustworthy or not.

I'll relate a story. The other day a guy I work with came in to our office and asked us to help him get his computer running again. We started it up, and it had a corrupted registry, we booted into knopix restored the registry from a restore point, and rebooted it just fine. On boot however there was clearly a barrage of services that shouldn't have been there, two antiviruses running at once, and a spyware removal tool we had never heard of. It's the spyware removal tool that interests me. Because I asked him about it.

> where did it come from, I've never heard of it

> I don't know, the Internet, I mean how am I supposed to know what's a good tool and isn't

There it is, how is he supposed to know what to trust and what not to trust. And I think this constant uncertainty plagues average computer users. How were they supposed to know that the wild tangent game would come bundled with bonzai buddy, or weather bug or spywareX.

inux distributions have what I feel is a pretty good solution to this. By having package management systems they reduce the number of sources you need to trust to one, the people that run your distro. You trust them to be a good filter, to test packages to make sure they're safe to install (both for stability and for privacy), and if they fail your trust you move to a new distribution, or change suppliers of packages. You still run into problems as soon as the user needs to install software outside of the scope of the management system, but these package databases are generally so large as to make that much less likely. Not to mention but these systems are far more accessible to your average home user. They can be set up for optimized or categorized searching, they can be expanded, they can be customized, and updates are sent in automatically. When I'm running in a Linux environment I trust that the software I'm getting is high quality, and safe. When I'm running OS X or Windows I don't trust the Internet, but the average home user does, they don't have any other options, and it costs them their privacy and the stability of their computers.

I don't believe that the current state of Linux installation is the be-all end-all. It sucks when something you want isn't in the package repository, and installing without that isn't well optimized, and certainly isn't simple enough for the home user, but it's a step up in safety for users.
