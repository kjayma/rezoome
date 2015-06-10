`import Ember from 'ember'`
`import config from './config/environment'`

Router = Ember.Router.extend
  location: config.locationType

Router.map ->
  @resource 'resumes', ->
    @route 'show', path: '/:resume_id'
  @route 'jobs'
  @route 'people'

`export default Router`

