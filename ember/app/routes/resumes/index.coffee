`import Ember from 'ember'`

ResumesIndex = Ember.Route.extend
  model: (params) ->
    @store.find 'resume'

`export default ResumesIndex`
