imagemagick = require 'imagemagick-native'
fs = require 'fs'
path = require 'path'
express = require 'express'
epeg = require 'epeg'

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
    image = new epeg.Image({data: data})
    width = +req.param('width')
    height = +req.param('height')

    buffer =
      if (image.width >= width && image.height >= height)
        image.downsize(width, height).process()
      else
        imagemagick.convert srcData: data, width: width, height: height, resizeStyle: "fill"
    res.set('Content-Type', 'image/jpg');
    res.send(buffer)

app.listen 3000
