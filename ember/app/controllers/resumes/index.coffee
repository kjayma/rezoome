`import Ember from 'ember'`

ResumesIndexController = Ember.Controller.extend
  queryParams: ['state', 'primary_email', 'last_name', 'first_name', 'location', 'radius', 'search_term']
  #state: null
  #primary_email: null
  #last_name: null
  #first_name: null
  #location: null
  #radius: null

`export default ResumesIndexController`
