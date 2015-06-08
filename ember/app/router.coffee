`import Ember from 'ember'`
`import config from './config/environment'`

Router = Ember.Router.extend
  location: config.locationType

Router.map ->
  this.resource 'job_search', ->
    this.resource 'candidates'
  this.route 'jobs'
  this.route 'people'

`export default Router`

