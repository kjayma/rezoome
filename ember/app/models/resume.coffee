`import DS from 'ember-data'`

App.Resume = DS.Model.extend ->
  lastName: DS.attr('string')

`export default DS.Model`
