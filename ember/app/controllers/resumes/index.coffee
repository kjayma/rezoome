`import Ember from 'ember'`

ResumesIndexController = Ember.Controller.extend
  queryParams: ['state', 'primary_email', 'last_name', 'first_name', 'zip', 'radius', 'search_term']
  state: null

`export default ResumesIndexController`
