`import DS from 'ember-data'`

DS.ActiveModelAdapter.extend
  namespace: 'api/v1'
  host: 'http://localhost:3000'

`export default DS.ActiveModelAdapter`
