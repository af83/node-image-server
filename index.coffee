path = require 'path'
fs = require 'fs'
express = require 'express'

Image = require './image'
config = require './config'

app = express()
app.get '/*', (req, res) =>
  filePath = path.join(config.root, req.path)
  return res.send(404) if !fs.existsSync(filePath)

  image = new Image filePath,
    req.param('width'),
    req.param('height'),
    req.param('quality')

  image.process (data, type) =>
    res.set('Content-Type', type);
    res.send(data)

console.log "Serve images from #{config.root} on port #{config.port}"
app.listen config.port
