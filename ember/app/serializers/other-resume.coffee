`import { ActiveModelSerializer } from 'active-model-adapter'`

OtherResumeSerializer = ActiveModelSerializer.extend DS.EmbeddedRecordsMixin,
  emptyprop: ->
    console.log('got here')

`export default OtherResumeSerializer`
