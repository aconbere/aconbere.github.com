---
layout: post
title: Solutions for Trust and the Internet
---
Continued from my post on <a href="http://anders.conbere.org/posts/trust-and-internet/">Trust and the OS</a>

So what do we do about trust, the web, and the modern computing platform. As I mentioned the Linux/BSD solution has some excellent aspects to it. The single line of trust, the filtering via "experts", the ability to manually check source code, but it breaks down when users expect the flexibility of the current popular model. Certainly we won't be dropping back on "make &amp;&amp; make install" any time soon in major Operating systems.

What I propose is a compromise. I think that windows and OS X should have built in package managers for commonly used applications. Windows' "Add and Remove Programs" is a poor attempt at package control and fails miserably with regards to administrative use. It lacks scripting support, isn't self aware, can't update itself, and has no control over 3rd party applications. So what are the requirements?

The operating system needs to restrict installation to packages that meet certain standards.

They have to define what files they are placing, where they are placing them, define the author the title, etc. All packages that fail to present this data will fail to install. OS X already provides a platform similar to this and won't install packages that don't meet it's requirements. This will enable the package manager to effectively keep track of applications installed, remove them or update them. Compare this to windows where third party applications are given free reign of what they want to do, just recently were third party applications prevented from attaching to the kernel in order to prevent root-kits (Much to the dismay of anti-virus providers). 3rd part application should in my opinion be by and large locked down to a few basic essentials, they should be forced to conform to the standard installation of the OS.

1. All packages should contain lists of their dependencies internal to themselves.
2. This should be provided in a standard method for the OS.
3. All package installed should be added to the list of installed applications in the package manager, and should be installed through the standard package manager interface (see point 4)
4. A collection of standard applications should be provided by the OS.

My biggest worry with this would be the owners of the OS providing privilege to a select few "partners" and excluding others. Perhaps a standardized method of submitting an application for inclusion and a oversight comity to prevent abuse could be implemented. This repository should include commonly installed packages, free or otherwise and could link to purchasing methods for those applications that aren't free. For example. If a user wanted to install photoshop, they might go to the windows package manager, search for art, see a list of packages with art tags, click the "buy this now" button for photoshop, and start their download. Or they might just see "Paint.net" and click install. The in both cases the package manager would handle dependencies (in paint.net that might include the .net runtime environment) and download install the necessary applications.

What does this provide for Operating systems like OS X and Windows?


* It gives users a centralized, and trusted place to start looking for applications.
* It provides a standard installation interface which has the capability of being much more clear and concise.
* It allows OS's like OS X or Windows to stop bundling all their own applications in, and offer a more free market place. While this isn't as a much of a worry for OS X without the monopoly litigation hamstringing it, it could be for Windows/Microsoft.

Consider this Microsoft's problems stem mostly from bundling software with their operating system, IE, Windows Media Player, etc. Yet these are critical applications in todays world, people won't accept a computer that doesn't by default have the tools to browse the web, play movies or music. If they were to stop providing any of these by default this would be a disaster, unless they provided a simple way for people to choose to install them on their own.

By having the base windows install be as simple as possible (no games, no office tools, no web browser, no media player) but having a simple package manager with all those tools on the install dvd, people could then choose on boot the applications they wanted, or choose "MS default" or various other options. This would encourage the idea of windows as a platform and allow more free competition.
