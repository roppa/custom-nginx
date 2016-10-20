# Custom nginx

The driving criteria for custom nginx containers is to:

- be able to create an nginx instance, passing in custom variables/custom conf files
- log error to stderr and access logs to stdout
- be able to test a container running nginx

##Overview

Our custom nginx image is based on the latest nginx vendor image.

The default nginx config sets charset, gzip, mime types, and log format. It also looks for the bespoke site config file at include ```/etc/nginx/sites/```.

When running you must mount your main **config file** to that path. If you have any included files, mount them and reference them in your ```conf``` file.

The static assets must be mounted to ```/usr/share/nginx/html```

##Running

An example is in the test folder and in the ```docker-compose.yml``` file in the root of this directory.

##Testing

The ```test``` folder contains the site/test.conf file, and the html folder. It is run manually at the moment using docker compose i.e. ```docker-compose up --build```.
