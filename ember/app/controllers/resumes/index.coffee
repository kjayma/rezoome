`import Ember from 'ember'`

ResumesIndexController = Ember.Controller.extend
  queryParams: ['state', 'primary_email', 'last_name', 'first_name', 'location', 'radius', 'search_term']

`export default ResumesIndexController`