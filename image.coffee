imagemagick = require 'imagemagick-native'
fs = require 'fs'
mmm = require 'mmmagic'
exif = require "exif"
ExifImage = exif.ExifImage

class Image

  magic = new mmm.Magic mmm.MAGIC_MIME_TYPE |
    mmm.MAGIC_NO_CHECK_TAR        |
    mmm.MAGIC_NO_CHECK_ENCODING   |
    mmm.MAGIC_NO_CHECK_TOKENS     |
    mmm.MAGIC_NO_CHECK_CDF        |
    mmm.MAGIC_NO_CHECK_TEXT       |
    mmm.MAGIC_NO_CHECK_ELF        |
    mmm.MAGIC_NO_CHECK_APPTYPE

  constructor: (path, width, height, quality)->
    @path = path
    @width = +width
    @height = +height
    @quality = +quality

  process: (done) ->
    fs.readFile @path, (err, data) =>
      magic.detect data, (err, type) =>
        switch type
          when "image/jpeg" then @processJPG data, done
          when "image/png"  then @processPNG data, done
          else @processGeneric data, done

  doResize: (data, convert)->
    imagemagick.convert
      srcData: data,
      width: @width,
      height: @height,
      quality: @quality,
      resizeStyle: "fill",
      format: convert

  processGeneric: (data, done) ->
    done @doResize(data, "jpeg"), "image/jpeg"

  processPNG: (data, done) ->
    done @doResize(data), "image/png"

  processJPG: (data, done) ->
    new ExifImage image: data, (error, exifData) =>
      # All orientation values between 5 and 8 are left or right sided
      if exifData && exifData.image.Orientation in [5, 6, 7, 8]
        [@width, @height] = [@height, @width]
      done @doResize(data), "image/jpeg"

module.exports = Image