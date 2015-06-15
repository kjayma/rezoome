`import Ember from 'ember'`

ResumesIndex = Ember.Route.extend
  model: (params, transition) ->
    @store.find 'resume', params

  actions:
    queryParamsDidChange: ->
      @.refresh()

`export default ResumesIndex`
