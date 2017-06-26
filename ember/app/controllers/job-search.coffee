`import Ember from 'ember'`
`import config from '../config/environment'`

JobSearchController = Ember.Controller.extend
  positionArray: config.APP.positionArray

  needs: ['resumes/index']

  selectedPositionIds: []

  actions:

    reset: ->
      resumes_index_controller = @get('controllers.resumes/index')
      query_params = resumes_index_controller.get('queryParams')
      thiscontroller = @
      query_params.forEach (param) ->
        thiscontroller.set(param, null)

      Ember.get(this, 'flashMessages').clearMessages()
      @transitionToRoute('job-search')

    selectPositions: ->
      selectedPositionIds = Ember.$(event.target).val()

      @set('selectedPositionIds', selectedPositionIds || [])
      @set('position', selectedPositionIds || [])
      console.log(@get('selectedPositionIds'))
      

`export default JobSearchController`
