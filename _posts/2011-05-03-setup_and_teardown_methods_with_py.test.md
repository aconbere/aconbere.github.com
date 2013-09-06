---
layout: post
title: Setup and Teardown Methods With Py.test
---

Not so long ago I picked up my unittest's and headed out for greener pastures. My first stop was <a href="http://code.google.com/p/python-nose/">nosetest</a> but I found that I had a hard time getting all my tests to work. The naming conventions just didn't seem to work out the way I thought they did, and after a day of experimenting I moved onwards. I ended up settling down in a nice little valley called <a href="http://codespeak.net/py/dist/test/index.html">py.test</a>, part of the <a href="http://codespeak.net/py/dist/">py.lib</a> suite of tools. It has much the same flavor as nose tests. There are no explicit classes, all tests are collected via a naming scheme, but it just worked out better for me.

{% highlight python %}
def test_preferences():
    assert("I like py.test")
{% endhighlight %}

My needs were simple, the valley was fertile, life was good.

Now more recently I needed some more complex setup and teardown methods for Igor...and the valley grew a little darker. The documentation for this was split between two versions. Ian Bicking had a <a href="http://ianbicking.org/docs/pytest-presentation/pytest-slides.html">slide deck</a> up that documented using decorators to accomplish this task. But implementing that I got errors about guards. The <a href="http://codespeak.net/py/dist/test/funcargs.html#application-specific-test-setup-and-fixtures">online documentation</a> mentioned something about using funcargs but I really didn't get how it all came together, and didn't mention teardown.

So here's how you do it.

First let's talk a bit about funcargs. Funcargs is a little magic feature that reaches into your function definitions and looks at the arguments a function expects.

{% highlight python %}
def test_my_function(arg):
    assert(arg)
{% endhighlight %}

Then using the argument name, matches that against a function defined in a special python module conftest.py. So in this case it would look for.

{% highlight python %}
def pytest_funcarg__arg(request):
    return False
{% endhighlight %}

Now magically the result of pytest_funcarg__arg would show up as "arg" in test_my_function. This alone would solve our setup problem. But figuring out teardown requires that we know a little bit about that request variable. As it turns out this isn't particularly hard either! If for instance we wanted to test a database, installing a set of fixtures and then destroying them after our tests or setup might look like this.

{% highlight python %}
# conftest.py
def setup_fixtures():
    db.insert(...)
    return db

def teardown_fixtures(db):
    db.destroy(..)

def py_test_funcarg__db(request):
    return request.cached_setup(
        setup = setup_fixtures,
        teardown = teardown_fixtures,
        scope = "module)

# test_db.py
def test_db(db):
    assert(len(db.query(x=y)) &gt;= 1)
{% endhighlight %}

This cached_setup stores the results of py_test_funcarg__db and reuses it for each test function in a given scope (here we're using module level scope). To instantiate the arg it calls the setup function, and when the scope exists it calls the teardown method with that arg.

I can't claim to like how magic all of this feels, but I do like that it works!
