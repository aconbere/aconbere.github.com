---
layout: post
title: Monads - Tools for everyday programming
---

At the first mention of Monads, even some of the most experienced engineers I know will turn into a clam shouting *blah* *blah* *blah* with their fingers in their ears. On the face of it this is a rather silly behavior, considering that these same engineers don't shy at the sight of other complicated programmatic abstractions. But I understand this reaction, Monads have long been the right of passage for young haskelers and they have had a tendency to shout the acquisition of this newfound knowledge to the stars. In many programmers' eyes this has bound Monads to Haskell. How unfair! After all, we don't relegate all functional programming to the trash bin because of the peculiarities of the Haskell community. Instead, let's try to understand what makes this structure so prevalent and why it's a useful abstraction.

## A Monad is a particular class of containers

For example, let's consider a simple little container object in JavaScript; we'll call it `Box`. 

```javascript
var Box = function (val) { this._value = val }
```

This box will have a few rules: no methods defined on `Box` may return the value it contains, methods can be written that have access to the value, but they must also return a Box.

Once you have a box, the natural thing to do with boxes is to put things in them. New boxes can be created simply `var box1 = new Box("a,b,c,d")`. Although it can be useful to simply have a place to put things, I would claim that this is a pretty boring object. Observing our rules, we can still write some interesting methods by passing in functions to them. For instance here's the definition of a method `map`, it takes a value in a `Box`, applies a function `f` to it, and puts the result in a new Box.

```javascript
Box.prototype.map = function (f) { return new Box(f(this._value)) }
var a = new Box(4)
a.map(function (i) { return i * i })
> Box(16)
```

 Naturally your life starts filling up with boxes quickly. But what do you do once you have two things inside of boxes and you want to touch both of them? Suppose we had two strings, `"a,b,c,d"` and `"e,f,g,h"` and we put them each in their own boxes.

```javascript
var box1 = new Box("a,b,c,d")
var box2 = new Box("e,f,g,h")
```

Looking at our two boxes and our two strings, we can see that the strings form the begining of the English alphabet. One sensible thing to do with these strings might be to concatenate them. But if we try to do that with our previous `map` method, we'll see that it causes some troubles.

```javascript
b.map(function (s1) { c.map(function(s2) { return s1 + "," + s2 }) })
> Box(Box("a,b,c,d,e,f,g,h"))
```

So we'll augment our box object one more time. This new method, called `flatMap`, will let us reach into boxes and do things so long as the function passed in returns a new box for us.

```javascript
Box.prototype.flatMap = function (f) {
  return f(this._value)
}
```

Attempting the concatention from before will now yield the correct answer.

```javascript
b.flatMap(function (s1) { c.map(function(s2) { return s1 + "," + s2 }) })
> Box("a,b,c,d,e,f,g,h")
```

## Maybe?

There's a particularly famous set of programing errors called "Null Pointer Errors". They come from trying to access information about data foud in memory but instead of giving the computer a valid memory address you give it a null value. One common way for these errors to manifest themselves is functions that may return null.

Here's an example:

```javascript
var NullyNullerson = function (i) {
  if (i % 2 === 0) {
    return i / 2
  } else {
    return null
  }
}

NullyNullerson(3)
> null
NullyNullerson(4)
> 2
```

When you have code like this a common pattern is to do a lot of error checking

```javascript
var myFunc = function(x,y,z) {
  var a = NullyNullerson(x)
  if (!a) { return false }

  var b = NullyNullerson(y)
  if (!b) { return false }

  var c = NullyNullerson(z)
  if (!c) { return false }

  return (x + y + z)
}
```

This kind of code tends to be get trickier over time as more programmers work on the code. It's common to believe that the function will never return null for the inputs you're giving, but to forget about an edge case. This error often looks like this.

```javascript
[2,4,6,7,8,10].map(function (i) {
  if (NullyNullerson(i).equals(2)) {
    console.log("yay hooray!")
  }
})
```

This function will fail with a null pointer exception since there is a bad value in the input array, which will result in NullyNullerson returning null. Unsurprisingly, Boxes can help us with this. First, we know we have two classes of outputs: those with values and those without. In other words, a Box with something (Some) in it, and an Emtpy box (None). Here again our boxes only implement the two methods `map` and `flatMap`.

```javascript
var None = function () {}
None.prototype = new Maybe();
None.prototpye.flatMap = function (f) { return new None() }
None.prototpye.map = function (f) { return new None() }

var Some = function (val) { this.value = val }
Some.prototype = new Maybe();
Some.prototype.flatMap = function (f) { return f(this.value) }
Some.prototype.map = function (f) { return new Some(f(this.value)) }
```

First let's rewrite `NullyNullerson`

```javascript
var MaybeMayberson = function (i) {
  if (i % 2 === 0) {
    return new Some(i / 2)
  } else {
    return new None()
  }
}

MaybeMayberson(3)
> None
MaybeMayberson(4)
> Some(2)
```

That seems like reasonable output, but now you might be asking how this will help us write less error-prone code. Let's observe what our error checking would look like using the Boxing methods we looked at earlier.

```javascript
var myFuncMaybe = function(x,y,z) {
  return MaybeMayberson(x).flatMap(function (a) {
    MaybeMayberson(y).flatMap(function(b) {
      MaybeMayberson(z).map(function(c) {
        return a + b + c
      })
    })
  })
}

myFunc(2,4,6)
> Some(6)

myFunc(2,5,6)
> None
```

This doesn't look any cleaner than it did before, but observe that simply by using our map and flatMap methods to access our boxed items, we have now avoided the null pointer exception, and short-circuited the error checking at the moment we hit None. This is much less error-prone and also observe that the Maybeness has become sticky, transforming our `myFunc` function into one that returns Maybes with ints in them. This is important because it means that any time you have a function that has the possibility of returning a None, it captures that behavior and exposes it up the call tree and it makes these methods easy to compose.

As the final coup de grace for this section, I'll introduce a little JavaScript library written by mozilla. [Sweet.js](http://sweetjs.org/) is a little macro preprocessor for javascript, and using it we can make Maybes a lot nicer to work with. The following mirrors Scala's for expressions in JavaScript.

```javascript
macro $for {
  case { $x:ident <- $y:expr } { $body:expr }=> {
    $y.map(function ($x) {
      return $body
    })
  }
 
  case { $x:ident <- $y:expr $rest ... } { $body:expr } => { 
    $y.flatMap(function($x) {
      return $for { $rest ... } { $body }
    })
  }
}
```

Using the for macro, we can write the error checking code again.

```javascript
// Note that this compiles to almost exactly the form of our previous
// version using map and flatMap
$for {
  a <- MaybeMayberson(x)
  b <- MaybeMayberson(y)
  c <- MaybeMayberson(z)
} {
  a + b + c
}
```

This is the expressive power of monads, here was have written what looks like an imperitive program. First to a, then do b, then do c, return a + b + c, but we have built it on an abstraction that prevents us from making an entire class of errors. It has made our lives simpler, and easier, hiding the complexity of the error.

## Looking Behind the Curtain

It's fair to question at this point, if perhaps maybe's are the only real useful bit of Monads, and if that's the case if there isn't a simpler abstraction to talk about them. As it turns out many of the things that we do as programmers can be encoded as a monad, and since the for macro we built earlier works on all macros, it's easy to reuse this pattern. Here are some other famous monads.

## The List Monad

The list monad, which we breifly mentioned in discussion how monads can be thought of as a class of containers, is to me the most digestable and obvious of the monads. Here our for macro provides a simple syntax for nested loops.

```javascript
Array.prototype.flatMap = function (f) {
  return Array.prototype.concat([], $this.map(f))
}

// this will loop through nested lists
var a = [1,2]
var b = [5,6]
$for {
  i <- a
  j <- b
} {
  i + j
}
> [6, 7, 7, 8]
```

## The Future Monad

With the Promises/A proposal promises are making a big stink in Javascript land. One nice property of promises is that they can be encoded as a Monad! In that case the for macro will compose the various promises and return a new promise that returns you the result of the computation.

```javascript
// I'm skipping a lot of details here for the sake of berevity, let's just
// assume that for our purposes the future variable here is a method that our
// underlying implementation will run asynchronously.
var Future = function(future) {
  this.future = future
}

Future.prototype.map = function (f) {
  return new Future(function () {
    return f(this.future())
  })
}

Future.prototype.flatMap = function (f) {
  return f(this.future());
}

Future.prototype.onSuccess = function (f) {
  return f(this.future());
}

var dbQuery1 = new Future(function () { return db.req("select * from my_table where x > 1 limit 1;") })
var httpRequest = new Future(function () { return http.get("http://example.com") })

var result = $for {
  a <- dbQuery1
  b <- httpRequest
} {
  a.x + JSON.parse(b)["x"]
}

result.onSuccess(funtion(xs) { console.log(xs) });
```

## Heading back to Kansas

Hopefully I've layed a few interesting ways that we can use the Monad abstraction in everyday programming, and ways that this sort of thinking can result in less error prone, easier to reason about programs. And maybe next time you hear some haskler yammering about monoids in the category of endofunctors, you can take a deep breath, think "they're just talking about a useful pattern of collections" and try to see why what they're using might help you.


