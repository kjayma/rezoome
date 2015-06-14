`import Ember from 'ember'`
`import config from './config/environment'`

Router = Ember.Router.extend
  location: config.locationType

Router.map ->
  @resource 'resumes', path: '/resumes', ->
    @route 'index', path: '/', ->
      @route 'show', path: '/:resume_id', ->
        @route 'show-file', path: '/:resume_grid_fs_id'
  @route 'jobs'
  @route 'people'

`export default Router`

