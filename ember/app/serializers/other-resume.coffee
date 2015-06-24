`import DS from 'ember-data'`

OtherResumeSerializer = DS.ActiveModelSerializer.extend DS.EmbeddedRecordsMixin,
  emptyprop: ->
    console.log('got here')

`export default OtherResumeSerializer`
