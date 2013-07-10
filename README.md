node-image-server
=================

Node server to serve, convert and resize images on demand

It support bmp, jpg and png.
It use http content negociation to deliver the appropriate image quality.

### Install and run

```
npm install
coffee index.coffee
```

All images files are served from the `public/` repository.

### Nginx configuration

The following Nginx configuration create a 200M cache for the resized
images:

```
# mkdir -p /var/cache/www/resize
# chown www-data:www-data /var/cache/www/resize

proxy_cache_path   /var/cache/www/resize levels=1:2 keys_zone=resize:200m;

upstream resize {
  server 127.0.0.1:4000;
}

server {
  server_name example.com;

  location / {
    proxy_pass http://resize/;
 
    proxy_cache        resize;
    proxy_cache_valid  200 302 304 12h;
    proxy_cache_key    $uri$is_args$args;

    proxy_ignore_headers Cache-Control Expires;
  }
}
```

### API

  - width: scale to this width
  - height: scale to this height
  - quality: quality value between 0 (low) and 100 (high)

```
curl http://localhost:3000/test.jpg?width100&height=100&quality=80
```
