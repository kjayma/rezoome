`import DS from 'ember-data'`

DS.ActiveModelAdapter.extend ->
  namespace: 'api/v1'

`export default DS.ActiveModelAdapter`
