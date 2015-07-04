`import Ember from 'ember'`

ResumesIndexResumeRoute = Ember.Route.extend
  afterModel: ->
    console.log('res mod')

`export default ResumesIndexResumeRoute`
