`import DS from 'ember-data'`

OtherSerializer = DS.ActiveModelSerializer.extend DS.EmbeddedRecordsMixin,
  emptyprop: ->
    console.log('got here')

`export default OtherSerializer`
