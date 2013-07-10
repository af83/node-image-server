imagemagick = require 'imagemagick-native'
fs = require 'fs'
path = require 'path'
express = require 'express'
mmm = require 'mmmagic'

exif = require "exif"
ExifImage = exif.ExifImage

config =
  root: "./public"
  port: 4000

magic = new mmm.Magic(mmm.MAGIC_MIME_TYPE)

app = express()
app.get '/*', (req, res) =>
  filePath = path.join(config.root, req.path)
  if !fs.existsSync(filePath)
    return res.send 404

  fs.readFile filePath, (err, data) ->
    sendResized = (type, width, height) ->
      console.log "resize to #{width}/#{height} and convert to #{type}"
      buffer = imagemagick.convert
        srcData: data,
        width: width,
        height: height,
        resizeStyle: "fill"
      res.set('Content-Type', type);
      res.send(buffer)
    
    width = +req.param 'width'
    height = +req.param 'height'

    magic.detect data, (err, type) ->
      if type == "image/jpeg"
        new ExifImage image: data, (error, exifData) ->
          # All orientation values between 5 and 8 are left or right sided
          if exifData && exifData.image.Orientation in [5, 6, 7, 8]
            [width, height] = [height, width]
          sendResized(type, width, height)
      else
        sendResized(type, width, height)

app.listen config.port
