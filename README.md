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

### API

  - width: scale to this width
  - height: scale to this height

```
curl http://localhost:3000/test.jpg?width100&height=100
```
