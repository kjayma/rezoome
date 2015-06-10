`import Ember from 'ember'`

Ember.Route.extend
  model: ->
    @store.find('resume')

`export default Ember.Route`
