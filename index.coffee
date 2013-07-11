path = require 'path'
fs = require 'fs'
express = require 'express'

Image = require './image'
config = require './config'

app = express()
app.get '/*', (req, res) =>
  filePath = path.join(config.root, req.path)
  fs.exists filePath, (exists) =>
    return res.send(404) unless exists

    image = new Image filePath,
      req.param('width'),
      req.param('height'),
      req.param('quality')

    image.process (data, type) =>
      res.set('Content-Type', type);
      res.send(data)

console.log "Serve images from #{config.root} on port #{config.port}"
app.listen config.port
