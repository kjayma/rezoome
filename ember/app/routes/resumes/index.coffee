`import Ember from 'ember'`

ResumesIndex = Ember.Route.extend
  model: ->
    @store.find 'resume'

`export default ResumesIndex`
