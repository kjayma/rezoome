`import Ember from 'ember'`

JobSearch = Ember.Route.extend

  actions:

    reset: ->
      Ember.$('#state').val(null)
      Ember.$('#location').val(null)
      Ember.$('#radius').val(null)
      Ember.$('#last_name').val(null)
      Ember.$('#first_name').val(null)
      Ember.$('#zip').val(null)
      Ember.get(this, 'flashMessages').clearMessages()
      @transitionTo('job-search')

`export default JobSearch`
