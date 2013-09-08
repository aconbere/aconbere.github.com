---
layout: post
title: The semigroup, or how a bunch of math snuck into my program
---

This is a story about an idea, an abstraction if you will. As software developers we deal in abstractions constantly, but I want to talk to you about one particular idea, the idea of `+`. Addition is pretty fundamental as a concept, so let's run through the basics. You'll be familiar with some common forms of addition like integer addition `1 + 2 = 3` and rational addition `1/2 + 2/3 = 7/6`. But what does it mean to be able to add something? Could we add functions? What about optional values?

One answer to that question is provided by [algebra](http://en.wikipedia.org/wiki/Abstract_algebra) a lot of algebra is spent defining sets of things and what operations can be performed on them. And what algebra will tell us is that the things we tend to think of as being addable are generally called Semigroups. A Semigroup is a set where all items in the set can be added together so that for every `a`, `b`, and `c` in the set `(a + b) + c = a + (b + c)`. If the set has an identity element (`0` for example), then we call it a `Monoid`. If every element has an inverse (1, -1, 2, -2) then we call it a `Group`. If the addition is commutative we call it an `Abelian Group`.

Strings are an interesting example of one such structure we work with everyday when programming. Strings it turns out meets the definition of a `Monoid`. The identity element is the empty string "", the `+` operator defines addition.

```scala
("a" + "b") + "c"
=> "abc"

"a" + ("b" + "c")
=> "abc"

"a" + ""
=> "a"

"" + "a"
=> "a"
```

I hinted earlier that Option's might also be addable, but the answer to that is slightly more complex. Any option defined over an addable type is itself addable. So let's take our string example from before. Let's define None as our identity.

```scala
Some("a") + None
=> Some("a")

None + Some("a")
=> Some("a")
```

And let's simply define the + operator on Some to just add what's inside it.

```scala
Some("a") + Some("b")
=> Some("ab")
```

This definition of addition on `Option[String]` is only a little suspect because it breaks a rule about the uniqueness of identity elements, since `Some("")` is also an identity element along with `None`, but I think this is a fairly impractical thing to worry about for this article.

At this point I wouldn't blame you for thinking "So what?". It's a common refrain when some math wonk starts going off about category theory and Haskell. So I want to illuminate how thinking about this kind of structure can provide unique insights into how to structure programs.


This sort of stuff usually bores programmers to death. "So what, I can add strings, we call that concatination. I knew these things already". To tackle that issue the next part here is going to cover a prticular case study of a 

## A case study in the use of Semigroups

I've been working on a Scala [irc library](https://github.com/aconbere/scala-irc) in my free time. Over the last week or so I've been refining the api to make it more palatable to work on. So I want to talk a little bit about the chain of decisions that have lead me to this place.

Early on I decided to take the Tokens returned by the parser and reuse them as Extractors to match against incoming messages and as the core datastructure for producing messages in responses.

```scala
// produces a Message instance in this case a ping from irc.example.com to our client
val message = Message(None, Command("PING"), List("irc.example.com"))

// match against the ping and respond with a pong
message match {
  case Message(_, Command("PING"), List(from)) =>
    Message(None, Command("PONG"), List(from))
  ...
}
```

To make this kind of work easier I defined a number of different `Extractors` that mirror common message patterns in IRC. For example in the above case there exists both a `Ping` and a `Pong` extractor which simplify the above to:

```scala
val message = Ping("irc.example.com")

message match {
  case Ping(from) => Pong(from)
  ...
}
```

### Combining responses

Early clients would define a method `messageHandler` that took in a `Message` and responded with an `Option[Message]`. This worked pretty well to get started but it quickly became apparent that I needed to be able to respond with multiple messages at once. In particular in order to authenticate to a server IRC requires sending three seperate messages PASS, USER, and finally NICK.

To handle this case I decided that Messages should be addable so that producing the authentication response was as simple as:

```scala
Pass("example") + User("aconbere") + Nick("aconbere")
```

The code to make that happen looks something like:

```scala
trait Response {
  def +(r:Response):ResponseCollection
}

class ResponseCollection(val responseList:List[Response]=List()) extends Response {
  def +(r:Response) = new ResponseCollection(responseList :+ r )
}

case class Message(...) extends Response {
  def +(r:Response) = new ResponseCollection(List(this, r))
```

What I've done is defined a new `+` operator on `Response`, the idea of an identity response or an inverse response is pretty silly, so what we've got here is a `Semigroup`. Though at this point that's still just a label that we can use to describe the structure.

### Combining handlers

One of the first things that failed in this design was that I wanted to be able to combine handlers. Since all clients need to be able to respond to pings and authenticate, I wanted to be able to give developers an easy way to handle those default behaviors and focus on everything else. Because I was using match statements to catch messages I wanted to handle and optionally returning responses, I knew that I was already dealing with a object that scala calls a [PartialFunction](http://www.scala-lang.org/api/current/index.html#scala.PartialFunction). PartialFunctions provide us a really useful function for doing this exact sort of thing called `orElse` which "Composes this partial function with a fallback partial function which gets applied where this partial function is not defined." This is what that looks like.

```scala
type MessageHandler = PartialFunction[Message, Option[Response]]

val defaultHandler:MessageHandler = {
  case Ping(from) => Some(Pong(From))
  case Mode(_) => Some(Pass(password) + User(userName) + Nick(nickName))
  case _ => None
}

val echoHandler:MessageHandler = {
  case PrivMsg(from, to, text) =>
    some(PrivMsg(from, text))
}

val messageHandler = defaultHandler orElse echoHandler
```

### Adding options

That design worked until my coworker Brad, has been the only other user of the library besides myself, wanted to combine handlers together so that both handlers would get a message and we would combine the responses. My first attempts were something like.

```scala
// sends a message to a chan every ping from the server
val tick:MessageHandler = {
  case Ping(_) =>
    PrivMsg("#chan", "hi")
}

def messageHandler(message:Message):Option[Message] = {
  val h1 = (defaultHandler orElse echoHandler)

  var r1 = None
  var r2 = None

  if (h1.isDefinedAt(message)) {
    r1 = h1(message)
  }

  if (tick.isDefinedAt(message)) {
    r2 = tick(message)
  }

  ???
}
```

But we can use what we know about semigroups to simplify this. We already know that `Option[Semigroup]` forms a `Semigroup` and we know Response forms a `Semigroup`. So let's make our lives easier my making `Option[Response]` addable.


```scala
implicit class AddableOptionResponse(a:Option[Response]) {
  def + (b:Option[Response]):Option[Response] =
    (a,b) match {
      case (None, None) =>None
      case (x@Some(_), None) => x
      case (None, y@Some(_)) => y
      case (Some(x), Some(y)) => Some(x + y)
    }
  }
}
```

That makes it clear what those `???` become since now we can just add the responses and return `r1 + r2`. But clearly that mess of mutable variables isn't ideal. At this point the pattern should be becoming clear. If `Option[Response]` forms a Semigroup, maybe `PartialFunction[T,Semigroup]` does as well. In fact it becomes pretty clear looking at the `lift` method which "Turns this partial function into an plain function returning an `Option` result."

Using our new found knowledge we can define a last and final `+` operator.

```scala
implicit class AddableMessageHandler(a:MessageHandler) {
  def + (b:MessageHandler):MessageHandler =
    new PartialFunction[Message, Option[Response]] {
      def apply(m:Message) =
        a.lift(m).getOrElse(None) +
        b.lift(m).getOrElse(None)

      def isDefinedAt(m:Message) =
        a.isDefinedAt(m) || b.isDefinedAt(m)
    }
}
```

Using this operator our client code now looks like.

```scala
val messageHandler:MessageHandler = (defaultHandler orElse echoHandler) + tick
```

And that's a long way to say "If you know a little bit about algebra you'll find out you can do arithmatic in unusual ways"

As a final remark I want to suggest that this whole notion of making operators one at a time is pretty silly, and that if we're thinking like good little developers we should be thinking, "how can I make this general". And of course the answer is not only that it's not terribly difficult but also that it's already been done for you. You can take a look at the [Semigroup type](https://github.com/scalaz/scalaz/blob/master/core/src/main/scala/scalaz/Semigroup.scala) in Scalz or I have a little [example](https://github.com/aconbere/scala-algebra/blob/master/src/main/scala/SemiGroup.scala) that I've been working on for my own enrichment.

Using my little library you can see how it becomes more useful.

```scala
import org.conbere.algebra.SemiGroup._

// I defined the +| operator instead of + to prevent confusion
Option.empty +| Option(1) +| Option(3)
=> Option(4)
```

Sadly there are some type oddities with the scala compiler being exposed here (specificly it has trouble figuring out that Some is of type Option in the above expressions).
