`import Ember from 'ember'`
`import config from './config/environment'`

Router = Ember.Router.extend
  location: config.locationType

Router.map ->
  @resource 'resumes', ->
    @resource 'resume', path: '/:id'
  @route 'jobs'
  @route 'people'

`export default Router`

