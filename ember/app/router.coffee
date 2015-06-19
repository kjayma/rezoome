`import Ember from 'ember'`
`import config from './config/environment'`

Router = Ember.Router.extend
  location: config.locationType

Router.map ->
  @route 'job-search', path: '/', ->
    @resource 'resumes', path: '/resumes', ->
      @route 'index', path: '/', ->
        @route 'resume', path: '/:resume_id'
  @route 'jobs'
  @route 'people'

`export default Router`

