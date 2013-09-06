---
layout: post
title: Igor Design Part 2
---

In the <a href="http://anders.conbere.org/blog/2009/08/22/concatinative_versus_object_oriented_design/">last post</a> on Igor I was describing some struggles I was having with an internal urge to make better use of python's generators in Igor by building a concatinative design. Really the discussion devolved into a rant about some issues I was having, and I just wanted to do an update and say that I've solved some of them.

The first thing that I noticed was that I could dramatically simplify the pieces by putting all of the path management into the Config class. Not only does this make sense in the grand scheme of things (paths are actually part of the config) but it meant that opposed to spreading that work out over many functions, it was all nicely self contained where it mattered. The result is that the publish function is nearly half the weight of what it used to be.

{% highlight python %}
def publish(source, destination=""):
    config = Config(source, destination)

    posts = make_posts(config.posts_dir, extensions=list(markup.extensions()))
    HomePage(posts), Feed(posts), Archive(posts)

    context = dict(documents = Document.all(), **config)

    publisher = Publisher(config.destination, config.templates_dir, context)
    [publisher.publish(d) for d in Document.all()]

    copy_supporting_files(config.source, config.destination)
{% endhighlight %}

versus...

{% highlight python %}
<pre><code>def publish(source, destination=""):
    paths = prepare_paths(source, destination)
    config = Config(paths['source'])

    paths['destination'] = paths['destination'] or config.get("publish_directory")
    assert(paths['destination'], "A destination directory is required")

    posts_path = path.join(paths['destination'], config.get("posts_prefix"))
    prepare_destination(paths['destination'])

    posts = find_posts(paths['source'], prefix=posts_dir, extensions=list(markup.extensions()))
    docs = posts + [HomePage(posts), Feed(posts), Archive(posts)]

    print(config)
    context = {'documents': documents}
    context.update(config)

    env = environment(paths['templates'], global_context=context)
    [write(doc, env, posts_path) for doc in docs]
    copy_supporting_files(paths['source'], paths['destination'])
{% endhighlight %}

Now I'm starting to feel good about this. My next goal is to abstract the source control tools being used. While my focuse is on Git, having it tightly bound seems like a bit of a cludge. And I suspect it will simplify some of the complexity found in the published_date, author, email etc. functions.
