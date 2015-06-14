`import Ember from 'ember'`

ResumeRoute = Ember.Route.extend

  model: (params) ->
    @store.find 'resumes/file', params.resume_grid_fs_id

`export default ResumeRoute`
