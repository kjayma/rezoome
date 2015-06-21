`import Ember from 'ember'`

ResumesIndexController = Ember.ArrayController.extend
  queryParams: ['state', 'primary_email', 'last_name', 'first_name', 'location', 'radius', 'search_term']

  resumeCount: ( ->
    @.get('length')
  ).property('model')

`export default ResumesIndexController`
