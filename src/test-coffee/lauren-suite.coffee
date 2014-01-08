vows = require('vows')
assert = require('assert')
suite = vows.describe('Testing Lauren Generator')

lauren = require('../js/lauren.js')

String::endsWith = (suffix) ->
  @indexOf(suffix, @length - suffix.length) isnt -1

suite.addBatch
  "Building empty objects":
    topic: ->
      lauren.buildGenerator
    'has 10 empty objects': (generator) ->
      assert.lengthOf generator(10).generate(), 10
    'has 0 empty objects': (generator) ->
      assert.equal generator(0).generate().length, 0

suite.addBatch
  "Building random string objects":
    topic: ->
      generator = lauren.buildGenerator(1)
      generator.addRandomString("test", 10)
      generator.generate()[0]
    'key should be named "test"': (output) ->
      keys = (key for key of output)
      assert.equal keys[0], "test"
    'value should be of length 10': (output) ->
      assert.equal output.test.length, 10

suite.addBatch
  "Building static string objects":
    topic: ->
      generator = lauren.buildGenerator(1)
      generator.addStaticString("test", "value")
      generator.generate()[0]
    'key should be named "test"': (output) ->
      keys = (key for key of output)
      assert.equal keys[0], "test"
    'value should be "value"': (output) ->
      assert.equal output.test, "value"

suite.addBatch
  "Testing adding multiple string objects":
    topic: ->
      generator = lauren.buildGenerator(1)
      generator.addRandomString("test1", 2)
      generator.addRandomString("test2", 4)
      generator.generate()[0]
    'should contain key named "test1"': (output) ->
      keys = (key for key of output)
      assert.equal keys.indexOf("test1"), 0
    'should contain key named "test2"': (output) ->
      keys = (key for key of output)
      assert.equal keys.indexOf("test2"), 1
    'value of test1 should be of length 2': (output) ->
      assert.equal output.test1.length, 2
    'value of test2 should be of length 4': (output) ->
      assert.equal output.test2.length, 4
  
suite.addBatch
  "Test regex object properties":
    topic: ->
      generator = lauren.buildGenerator(1)
      generator.addRegexString("test", /hello+ (world|to you)/)
      generator.generate()[0]
    'should contain key named "test"': (output) ->
      keys = (key for key of output)
      assert.notEqual keys.indexOf("test"), -1
    'value of test should start with hello': (output) ->
      assert output.test.indexOf("hello") is 0
    'value of test should end with "world" or "to you"': (output) ->
      world = "world"
      toYou = "to you"
      assert (output.test.endsWith world) or (output.test.endsWith toYou)

suite.addBatch
  "Test Empty Generator Generator":
    topic: ->
      generator = lauren.buildGenerator 1
      generator.addGenerator("subgenerator", lauren.buildGenerator 0)
      generator.generate()[0]
    'should contain key named "subgenerator"': (output) ->
      keys = (key for key of output)
      assert.notEqual keys.indexOf("subgenerator"), -1
    'value should render as empty array': (output) ->
      assert.equal JSON.stringify(output.subgenerator), "[]"

suite.addBatch
  "Given a simple Generator Generator":
    topic: ->
      generator = lauren.buildGenerator 1
      subgen = lauren.buildGenerator 1
      subgen.addStaticString("test", "ok")
      generator.addGenerator("subgenerator", subgen)
      generator.generate()[0]
    'should contain key named "subgenerator"': (output) ->
      keys = (key for key of output)
      assert.notEqual keys.indexOf("subgenerator"), -1
    'value should render as empty array': (output) ->
      assert.equal output.subgenerator[0].test, "ok"



suite.run()


