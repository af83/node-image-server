assert = require 'assert'
expect = require 'expect.js'
gm = require 'gm'
Image = require '../image'

describe 'image', ->
  describe '#new()', ->
    it 'should create an image object', ->
      image = new Image "test/fixtures/test.jpg", 10, 15, 20
      assert.equal image.width, 10
      assert.equal image.height, 15
      assert.equal image.quality, 20

  describe "#process()", ->
    it "should process a JPEG image", (done) ->
      image = new Image "test/fixtures/test.jpg", 10, 15, 20
      image.process (data, type) ->
        gm(data).identify (err, identity) ->
          assert.equal type, "image/jpeg"
          assert.equal identity.format, "JPEG"
          assert.equal identity['JPEG-Quality'], '20'
          assert.equal identity.size.width, 10
          assert.equal identity.size.height, 15
          done()

    it "should process a BMP image", (done) ->
      image = new Image "test/fixtures/test.bmp", 11, 16, 21
      image.process (data, type) ->
        gm(data).identify (err, identity) ->
          # BMP image are translated to JPEG
          assert.equal type, "image/jpeg"
          assert.equal identity.format, "JPEG"
          assert.equal identity['JPEG-Quality'], '21'
          assert.equal identity.size.width, 11
          assert.equal identity.size.height, 16
          done()

    it "should process a PNG image", (done) ->
      image = new Image "test/fixtures/test.png", 12, 17
      image.process (data, type) ->
        gm(data).identify (err, identity) ->
          assert.equal type, "image/png"
          assert.equal identity.format, "PNG"
          assert.equal identity.size.width, 12
          assert.equal identity.size.height, 17
          done()