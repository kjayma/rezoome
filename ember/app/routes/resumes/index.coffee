`import Ember from 'ember'`

ResumesIndex = Ember.Route.extend
  model: (params, transition) ->
    params_array = $.map params, (value, index) -> value

    real_params = params_array.filter (item) ->
      return item != "undefined" && item != ""

    if real_params.length == 0
      alert("Please enter at least one search term - you would wait a long time if we don't narrow down the search!")
      transition.abort()
    else
      @store.find 'resume', params

  actions:
    queryParamsDidChange: ->
      @.refresh()

  resumeCount: -> (
    @.get("model.resume.length")
  ).property("model.resume.[]")

`export default ResumesIndex`
