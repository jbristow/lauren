vows = require('vows')
assert = require('assert')
suite = vows.describe('Fake Edda Responses')


fakeedda = require('../js/fakeedda')

suite.addBatch
  "Using fakeedda's instanceUrl generator": 
    topic: ->
      fakeedda.instanceUrl
    'is correct for us-west-1': (testFunct) ->
       assert.equal testFunct('fps-perf','us-west-1'), '/edda/us-west-1/fps-perf/view/instances;_pp;_expand'
    'is correct for us-west-2': (testFunct) ->
       assert.equal testFunct('fps-perf','us-west-2'), '/edda/us-west-2/fps-perf/view/instances;_pp;_expand'
suite.addBatch
  "Using fakeedda's userUrl generator":
    topic: ->
      fakeedda.userUrl
    'is correct for "default"': (testFunct) ->
      assert.equal testFunct('default'), '/edda/default/aws/iamUsers;_pp;_expand'
    'is correct for "fps-perf"': (testFunct) ->
      assert.equal testFunct('fps-perf'), '/edda/fps-perf/aws/iamUsers;_pp;_expand'
suite.addBatch
  "Matching user url":
    topic: ->
      fakeedda.matchesUserUrl
    'does not match': (matcher) ->
      assert.equal false, matcher('fps-perf', '/edda/default/aws/iamUsers;_pp;_expand')
    'matches': (matcher) ->
      assert matcher('fps-perf', '/edda/fps-perf/aws/iamUsers;_pp;_expand')
suite.addBatch
  "Matching instance url, single region":
    topic: ->
      fakeedda.matchesInstanceUrl
    'does not match, wrong account': (matcher) ->
      assert.equal false, matcher('fps-perf', 'us-west-1', '/edda/us-west-1/default/view/instances;_pp;_expand')
    'does not match, wrong region': (matcher) ->
      assert.equal false, matcher('fps-perf', 'us-west-1', '/edda/us-west-2/fps-perf/view/instances;_pp;_expand')
    'does not match, wrong region and account': (matcher) ->
      assert.equal false, matcher('fps-perf', 'us-west-1', '/edda/us-west-2/default/view/instances;_pp;_expand')
    'matches, wrong region and account': (matcher) ->
      assert matcher('fps-perf', 'us-west-1', '/edda/us-west-1/fps-perf/view/instances;_pp;_expand')
suite.addBatch
  "Matching instance url, multi-region":
    topic: -> fakeedda.matchesInstanceUrl
    'matches': (matcher) ->
      assert matcher('fps-perf', ['us-west-1', 'us-west-2'],  '/edda/us-west-1/fps-perf/view/instances;_pp;_expand')
    'does not match any': (matcher) ->
      assert.equal matcher('fps-perf', ['us-west-1', 'us-west-2'],  '/edda/us-west-3/fps-perf/view/instances;_pp;_expand'), false
    'does not match account': (matcher) ->
      assert.equal matcher('fps-perf', ['us-west-1', 'us-west-2'],  '/edda/us-west-1/default/view/instances;_pp;_expand'), false
    'does not match both': (matcher) ->
      assert.equal matcher('fps-perf', ['us-west-3', 'us-west-2'],  '/edda/us-west-1/default/view/instances;_pp;_expand'), false

suite.run()
