`import DS from 'ember-data'`

SearchLocation = DS.Model.extend
  coordinates: DS.attr()
  lat: (->
    @get('coordinates')[0]
  ).property('coordinates')
  long: (->
    @get('coordinates')[1]
  ).property('coordinates')

`export default SearchLocation`
