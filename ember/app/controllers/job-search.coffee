`import Ember from 'ember'`

JobSearchController = Ember.Controller.extend
  needs: ['resumes/index']

  actions:

    reset: ->
      resumes_index_controller = @get('controllers.resumes/index')
      query_params = resumes_index_controller.get('queryParams')
      thiscontroller = @
      query_params.forEach (param) ->
        thiscontroller.set(param, null)

      Ember.get(this, 'flashMessages').clearMessages()
      @transitionToRoute('job-search')

`export default JobSearchController`
