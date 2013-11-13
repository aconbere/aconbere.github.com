---
layout: post
title: On Code Reviews
---

When I am in the position of reviewing another developers code I look for three things.

1. Is code correct and free of obvious defects?
2. Is the code verifiable, can we test it?
3. Can I imagine the path from this design to my ideal?

The first two are an obvious part of most code reviews, the third might bear explanation.

When reviewing code it's easy to get caught in the trap of imparting your design sensibilities on that of the author. But design sensibilities are largely subjective and difficult to quantify, and falling into that trap can lead to long arguments with few positive outcomes. Focusing instead on whether the design accounts for the necessary modularity or flexibility to take it from it's current design to a new one, gives me the freedom to remove myself as gatekeeper and changes the tone of the conversation. Instead of critiquing design aspects, it becomes a discussion of external factors that might need to be considered, knowledge of other users of this code, or performance for example. If these factors have been thought about by the author I'm quick to mark it as good. If it turns out that the design had flaws, I've validated to myself that I believe the code could be rewritten to account for those flaws.

Lastly, this is a chance for me to be proven wrong. I am not perfect, I am often wrong. If all designs that exit review are molded in my image, what chance do I have to learn from my peers. Being proven wrong is an amazing opportunity to reevaluate your assumptions.
