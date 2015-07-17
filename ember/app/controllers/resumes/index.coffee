`import Ember from 'ember'`

ResumesIndexController = Ember.Controller.extend
  queryParams: ['state', 'primary_email', 'last_name', 'first_name', 'location', 'radius', 'search_term']
  state: null
  primary_email: null
  last_name: null
  first_name: null
  location: null
  radius: null

  isLocationSearch: (->
    state = @get('state')
    location = @get('location')
    if (location != 'undefined' && location != 'null' && location != undefined && location != null)
      @set('zoom', 7)
      true
    else if (state != 'undefined' && state != 'null' & state != undefined && state != null)
      @set('zoom', 5)
      true
    else
      false
  ).property('model')

`export default ResumesIndexController`
