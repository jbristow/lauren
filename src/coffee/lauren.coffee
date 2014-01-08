RandExp = require('randexp')
JSONSelect = require 'JSONSelect'

class GeneratorType

class Generator extends GeneratorType
  constructor: (@number_of_items) ->
    @members = []
    @variables = []
  addHash: (key, type) ->
    @members.push({key: key, type: type})
  addRandomString: (key, length) ->
    @addHash(key, new RandomStringGeneratorType(length))
  addRegexString: (key, regex) ->
    @addHash(key, new RegexStringGeneratorType(regex))
  addInteger: (key, min, max) ->
    @addHash(key, new IntegerGeneratorType(min, max))
  addBoolean: (key) ->
    @addHash(key, new BooleanGeneratorType())
  addStaticString: (key, value) ->
    @addHash(key, new StaticStringGeneratorType(value))
  addCombo: (key, types) ->
    @addHash(key, new ComboGeneratorType(types))
  addGenerator: (key, generator) ->
    @addHash(key, generator)
  addReference: (key, referent) ->
    @addHash(key, new PropertyAccessorGeneratorType(referent))
  addFromArrayRoundRobin: (key, array) ->
    @addHash(key, new ArrayRoundRobinGeneratorType(array))
  addFromArrayRandom: (key, array) ->
    @addHash(key, new ArrayRandomGeneratorType(array))
  addArray: (key, array, frequencies) ->
    @addHash(key, new ArrayGeneratorType(array, frequencies))
  addFromVariable: (key, variable_name) ->
    @addHash(key, new VariableFetchGeneratorType(variable_name))
  addInt: (key, min, max) ->
    @addHash(key, new IntegerGeneratorType(min, max))
  addNull: (key) ->
    @addHash key, new NullGeneratorType()
  addVariable: (varname, type) ->
    @variables.push({name: varname, type: type})

  output: (n) ->
    @number_of_items = n
    @generate(null, null, [])
  
  generate: (i, current_object, globals) ->
    output = new Array()
    members_to_generate = @members
    globals[variable.name] = variable.type.generate() for variable in @variables

    for i in [0...@number_of_items]
      object = {}
      object[member.key] = member.type.generate(i, object, globals) for member in members_to_generate
      output.push object
    output


class RandomStringGeneratorType extends GeneratorType
  constructor: (@length) ->
    @chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890-=!@#$%^&*&()_+,./<>?|\\~`"
  generate: ->
    output = ""
    output += @chars[Math.floor(Math.random() * @chars.length)] for i in [0...@length]
    output


class RegexStringGeneratorType extends GeneratorType
  constructor: (@regex) ->

  generate: ->
    new RandExp(@regex).gen();

class IntegerGeneratorType extends GeneratorType
  constructor: (@min, @max) ->

  generate: ->
    Math.floor(Math.random() * (@max - @min)) + @min

class FloatGeneratorType extends GeneratorType
  constructor: (@min, @max) ->

  generate: ->
    Math.random() * (@max - @min) + @min

class BooleanGeneratorType extends GeneratorType
  generate: ->
    Math.floor((Math.random() * 2) + 1) % 2 == 0

class StaticStringGeneratorType extends GeneratorType
  constructor: (@value) ->
  generate: ->
    @value

class PropertyAccessorGeneratorType extends GeneratorType
  constructor: (@property_name) ->
  generate: (i, for_object, globals) ->
    JSONSelect.match(@property_name, for_object)[0]

class ComboGeneratorType extends GeneratorType
  constructor: (@types)->
  generate: (i, for_object, globals) ->
      output = ""
      output += type.generate(i, for_object, globals) for type in @types
      output

class ArrayRoundRobinGeneratorType extends GeneratorType
  constructor: (@values) ->
  generate: (i, for_object, globals) ->
    @values[i%@values.length]

class ArrayGeneratorType extends GeneratorType
  constructor: (@values, @frequencies) ->
  generate: (i, for_object, globals) ->
    output = []
    for value,i in @values
      freq = @frequencies[i]
      freq = 1 if freq is undefined
      output.push(value) unless Math.random() >= freq
    output

class ArrayRandomGeneratorType extends GeneratorType
  constructor: (@values) ->
  generate: (i, for_object, globals) ->
    @values[Math.floor(Math.random() * @values.length)]

class VariableFetchGeneratorType extends GeneratorType
  constructor: (@name) ->
  generate: (i, for_object, globals) ->
    globals[@name]

class NullGeneratorType extends GeneratorType
  generate: (i, for_object, globals) ->
    null

exported = exports ? this

exported.buildGenerator = (number_of_items) ->
  new Generator(number_of_items)

exported.regexGeneratorType = (regex) ->
  new RegexStringGeneratorType(regex)

exported.accessorType = (property_name) ->
  new PropertyAccessorGeneratorType(property_name)

exported.fromVariableType = (variable_name) ->
  new VariableFetchGeneratorType(variable_name)


