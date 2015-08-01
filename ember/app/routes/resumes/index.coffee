`import Ember from 'ember'`
`import DS from 'ember-data'`


ResumesIndex = Ember.Route.extend
  model: (params, transition) ->
    params_array = $.map params, (value, index) -> value

    real_params = params_array.filter (item) ->
      return item != "undefined" && item != "" && item != null

    if real_params.length == 0
      Ember.get(this, 'flashMessages').clearMessages()
      Ember.get(this, 'flashMessages').warning("Warning: Please enter at least one search term - you would wait a long time if we didn't narrow down the search!")
      transition.abort()
    else
      store = @store
      @store.query('resume', params).then (resumes) ->
        return {
          resumes: resumes
          searchLocation: do ->
            loc = []
            store.all('search-location').forEach (location) ->
              loc = location.get('coordinates')
            return {lat: loc[1], lng: loc[0]}
        }

  setupController: (controller, model) ->
    @._super(controller,model)

  afterModel: (model) ->
    count = model.resumes.get('length')
    Ember.get(this, 'flashMessages').clearMessages()
    if count > 0
      Ember.get(this, 'flashMessages').info("Search completed successfully - " + count + ' results found.')
    else
      Ember.get(this, 'flashMessages').warning("Search completed but no matches found.")

  actions:
    queryParamsDidChange: ->
      @refresh()

    error: (error, transition) ->
      error_message = "Error: the search failed.  Try again or call support :)\n" + error.message
      Ember.get(this, 'flashMessages').danger(error_message)
      @transitionTo('job-search')

    switchResume: (target) ->
      resume = target.get('controller.model')
      @transitionTo('resumes.index.resume', resume )

`export default ResumesIndex`
