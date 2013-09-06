---
layout: post
title: Concatinative Versus Object Oriented Design
---

I finally moved my blog over to using <a href="http://github.com/aconbere/igor">Igor</a> my new static blog generator. A couple of things have fallen out of this work. First is a feeling of two design forces pulling me in opposite directions. I feel torn between the simple semantics of a group of functions and a few monolithic classes. The former doesn't feel particularly pythonic, but the latter doesn't feel particularly well designed.

Having seen some fantastic application design I can tell that Igor isn't the most well designed of programs. There are functions littered in modules that they don't belong, there are classes where there doesn't need to be and no classes where there should be! And I should have seen this coming. I set out on this project with the goal of not designing up front. Instead to build a working tools and to refine it. But I've found that the result is an application that works but lacks beauty.

So let's look at some of the problems here, and some solutions I've been working on.

The primary goal of Igor is to make publishing a simple, relatively static website simple for me. I've decided to accomplish this through simple parsing of text files and some opinionated choices on directory structure. A secondary goal related to the first is to allow me to do this with as little extra effort as possible. I don't want to have to use external scripts, I don't want to type out the date to get the published date, etc. To that end I've decided to make as much use of the Operating System and VCS as possible.

So the design needs to work something like.
Given source and destination directories

1. retrieve the names of all the text files in the _posts directory below it
1. parse each of them, applying an apporpriate markup filter
1. publish each post to an appropiately named directory in the destination
1. copy all files that aren't hidden or start with a _
1. provide a way to link to articles given an identifier
1. provide tools for building RSS feeds and Archives

The primary design goals turn out to be quite easy. First I retrieved all the files in a dir using os.listdir, then I got the file extension of the file and checked it against a list of extensions mapped to markup filters, and finally I split off a header, title and body section from the file and passed them through the markup filter. Publishing I grabbed the published data and crafted a simple Y/M/D/title/ scheme.

Things became tricky when solving 5 and 6.

For 5 I needed a way to store a canonical list of all the documents I had been working with. I decided to has all the documents I wanted to publish derive from the Document class, which provided the tools to track any new instances, including posts, archives or home_pages. All Documents register a "slug" (a string that removes characters not well suited for uri's) and then can be referenced by that slug. Using that I could then build a valid url given the slug of a given post, and solved 5.

For 6 I needed to collect the posts from 1, and reuse then in generating archives, feeds and home pages. At first I had a class based approach to my overall program. You would intialize the class with the source and destination. It would grab a config file, generate paths, and eventually aid in publishing all the documents. My second attempt I looked at a more concatinative approach. I knew the root of my app was simply a generator expression that yielded up new Posts as files were found in _posts. And I thought I could use that to make a simple design publishing each post as I recieved it. But then 6 came and bit me. To create collections I would have to create a list of posts at the end, regarless of my pretty itterator.

The end result was this rather ugly function...

{% highlight python %}
def publish(source, destination=""):
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

I'll keep working on this, and I'm not sure a beautiful solution exists. But I'm fairly sure it's not what I have there.
