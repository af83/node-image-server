assert = require 'assert'
expect = require 'expect.js'
Image = require '../image'

describe 'image', ->
  describe '#new()', ->
    it 'should create an image object', ->
      new Image "test/fixtures/test.jpg"
