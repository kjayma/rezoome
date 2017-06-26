`import Ember from 'ember'`
`import config from '../../config/environment'`

PeopleNewController = Ember.Controller.extend
  positionArray: config.APP.positionArray

  placeholder: ""
`export default PeopleNewController`
