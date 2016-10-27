# Custom nginx

The driving criteria for custom nginx containers is to:

- be able to create an nginx instance, passing in custom variables/custom conf files
- log error to stderr and access logs to stdout
- be able to test a container running nginx

## Overview

Our custom nginx image is based on the latest nginx vendor image.

This custom nginx has a base config file which sets charset, gzip, mime types, and log format.

We set specific folders for your sites config, an includes folder, and html folder.

The ```/etc/nginx/sites/``` folder is intended for you to attach your own ```.conf``` file.

The ```etc/nginx/includes/``` folder is intended for any includes you need in your conf file.

The ```/usr/share/nginx/html/``` folder is intended for your static assets.

## Running

There are many ways to run this. An example exists in the /test folder and the ```docker-compose.yml``` file in the root of this directory. The ```docker-compose.yml``` creates a container from the base image and mounts the folders (sites, html, config) using the command line.

Another approach is to attach the html/static assets is via a data container. In your SPA repository, build your site into a ```/dist``` folder for example (see '/data-volume-example'). Then create a data volume, adding the contents from '/dist':

```
docker create -v $(pwd)/dist:/usr/share/nginx/html --name html-dist debian /bin/true
```

Then create your nginx instance with your config file (but not adding any html):

```
FROM customnginx
COPY site.conf /etc/nginx/sites
```

Then build using something like:

```
docker build -t testcustom .
```

Once your image is built, you can run and attach your data volume using ```--volumes-from```:

```
docker run -d -p 8800:80 -v /usr/share/nginx/html --volumes-from html-dist testcustom
```

In this way you can keep your distribution code separate from your bespoke nginx, and for any other nginx instances that are span up the distribution files can be attached. This could be set to read only too (:ro).

Another way is to create a Dockerfile based on the custom container (next section).

## Building the default image

Create the base image in your repo (see '/bespoke-example'):

```
docker build -t [default image name] .
```

Then, in your specific Docker file use ```FROM [default image name]```. For example:

```
FROM customnginx

COPY site.conf /etc/nginx/sites
COPY ./html /usr/share/nginx/html
```

## Testing

The ```test``` folder contains the site/test.conf file, and the html folder. It is run manually at the moment using docker compose i.e. ```docker-compose up --build```.
