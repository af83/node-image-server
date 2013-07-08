imagemagick = require 'imagemagick-native'
fs = require 'fs'
path = require 'path'
express = require 'express'

root = "./uploads"

app = express()

app.configure ->
  app.use(app.router);
  app.use(express.errorHandler({ dumpExceptions: true, showStack: true }));

app.get '/*', (req, res) =>
  filePath = path.join(root, req.path)
  if !fs.existsSync(filePath)
    return res.send 404

  fs.readFile filePath, (err, data) ->
    width = +req.param('width')
    height = +req.param('height')

    buffer = imagemagick.convert
      srcData: data,
      width: width,
      height: height,
      resizeStyle: "fill"

    res.set('Content-Type', 'image/jpg');
    res.send(buffer)

app.listen 3000
