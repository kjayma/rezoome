`import Ember from 'ember'`

ResumesIndex = Ember.Route.extend
  model: (params, transition) ->
    params_array = $.map params, (value, index) -> value

    real_params = params_array.filter (item) ->
      return item != "undefined" && item != ""

    if real_params.length == 0
      Ember.get(this, 'flashMessages').clearMessages()
      Ember.get(this, 'flashMessages').warning("Warning: Please enter at least one search term - you would wait a long time if we didn't narrow down the search!")
      transition.abort()
    else
      @store.find 'resume', params

  afterModel: (resumes) ->
    count = resumes.get('length')
    Ember.get(this, 'flashMessages').clearMessages()
    if count > 0
      Ember.get(this, 'flashMessages').info("Search completed successfully - " + count + ' results found.')
    else
      Ember.get(this, 'flashMessages').warning("Search completed but no matches found.")


  actions:
    queryParamsDidChange: ->
      @.refresh()

    error: (error, transition) ->
      error_message = "Error: the search failed.  Try again or call support :)\n" + error.message
      Ember.get(this, 'flashMessages').danger(error_message)
      @transitionTo('job-search')

`export default ResumesIndex`
