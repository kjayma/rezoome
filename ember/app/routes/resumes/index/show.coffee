`import Ember from 'ember'`

ResumeRoute = Ember.Route.extend

  model: (params) ->
    @store.find 'resume', params.id

`export default ResumeRoute`
