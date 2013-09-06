---
layout: post
title: Deploying wsgi applications behind Nginx
---

There's a fine line in the world of web frameworks, if you dictate too many choices in for your users, they loose the ability to carry in knowledge they might already have, they feel constrained, and you dictate what can be accomplished. If you let things fly free, the number of choices crushes the developers ability to be productive. Werkzeug clearly lands more on the former, but helps bridge that gap with a great set of documentation, that lays out a clear path forward. The choices are there for you to make, but if you want to get going, the dev team there has provided you with a great set of defaults, and clear documentation on how to utilize them.

One place that the documentation for Werkzeug has lacked is on the topic of deployment. This was amended with the <a href="http://werkzeug.pocoo.org/documentation/deploying">latest release</a> but still didn't cover my use case, or at least didn't go into the amount of detail I would expect from deployment documentation. So I thought I would cover how I use Werkzeug in my deployed applications.

As a brief overview, I like to deploy my applications with <a href="http://peak.telecommunity.com/DevCenter/EasyInstall">easy_install</a> behind <a href="http://wiki.codemongers.com/Main">Nginx</a>, using <a href="http://pythonpaste.org/script/">Paster Serve</a> as my application host.

### Creating a setup.py install script

{% highlight python %}
from setuptools import setup, find_packages

setup(name='werkzeug_app',
    version='0.1',
    description='werkzeug_app',
    author='Anders Conbere',
    author_email='aconbere@gmail.com',
    url='http://anders.conbere.org/',
    packages=find_packages(),
    package_data = {'werkzeug_app': ['templates/*']},
    classifiers=['Development Status :: 1 - Alpha',
                 'Environment :: Web Environment',
                 'Intended Audience :: Developers',
                 'Operating System :: OS Independent',
                 'Programming Language :: Python',
                 'Topic :: Utilities'],

    install_requires = [
        "Werkzeug > 0.4.0",
        "Jinja2 >= 2.0",
        "SQLAlchemy >= 0.5.0",
        "Paste >= 1.7.0",
        "PasteDeploy >= 1.3.0",
        "PasteScript >= 1.7.0",
        "simplejson >= 2.0.0",
        "WTForms >= 0.3.1",
        ],

    entry_points={
        'paste.app_factory': [
            'main=werkzeug_app.application:app_factory',
            ],
        },
      )
{% endhighlight %}

This does a couple of things, that are nice for deploying. It defines my dependencies, and automatically installs them for me when I run the script. It set's up an entry point for Paster to grab onto later, and attaches some simple metadata about the application to it.

To install your app, now all you have to do is run

{% highlight bash %}
$> sudo python setup.py install
{% endhighlight %}

### Building a Paster config for running your app<

In order to have Paster run out servers we need to give it some basic configuration parameters.

{% highlight ini %}
[server:main]
    use = egg:Paste#http
    host = 0.0.0.0
    port = 8090
    use_threadpool = True
    threadpool_workers = 10

[app:main]
    use = egg:werkzeug_app
    db_uri = sqlite:////var/db/werkzeug_app/werkzeug_app.db
{% endhighlight %}

It should be relatively clear from this what's going on. The first set of config params sets up how our server works, defines the IP it binds to and a Port. The second set tells Paster where to find our code. Since we installed our app using easy_install as an egg, we need to tell Paster to look for that. On top of that we can pass extra data to our application at this point, so I choose to send in my database path as part of the config.

If you wanted to run many of these servers to load balance you would simply need to copy the two sets of configs for the "main" app, and give it a new name like "main2", and give that app a new ip or port to bind to. They could then be started separately.

These apps can then be run by issuing the paster serve command

{% highlight bash %}
> paster serve developemnt.ini --daemon
> paster serve -n main2 developement.ini --daemon
{% endhighlight %}

### Setting up Nginx to point back to your paster servers

I use the following simple Nginx config (this is probably not the best nginx config ever I just don't bother much with it).

{% highlight nginx %}
worker_processes  2;

events {
    worker_connections  1024;
}

http {
    client_body_timeout   5;
    client_header_timeout 5;
    keepalive_timeout     5 5;
    send_timeout          5;
    tcp_nodelay on;
    tcp_nopush  on;

    upstream werkzeug_apps {
        server localhost:8090;
        server localhost:8091;
    }

    server {
        listen       80;
        server_name  localhost;
        location / {
            proxy_pass http://werkzeug_apps;
            proxy_redirect default;
        }
    }
}
{% endhighlight %}

once again, you can run this by starting nginx, which can be invoked by running

{% highlight bash %}
> nginx -c nginx.conf
{% endhighlight %}

Breathe deeply and think about how awesome you are

Seriously, you rule! And now you not only rule, but have nginx hosting your werkzeug app as well.<
