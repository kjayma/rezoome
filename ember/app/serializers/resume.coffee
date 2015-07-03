#`import DS from 'ember-data'`
`import { ActiveModelSerializer } from 'active-model-adapter'`

ResumeSerializer = ActiveModelSerializer.extend DS.EmbeddedRecordsMixin, attrs:
  otherResumes: embedded: 'always'

`export default ResumeSerializer`
