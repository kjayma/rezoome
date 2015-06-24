`import DS from 'ember-data'`

ResumeSerializer = DS.ActiveModelSerializer.extend DS.EmbeddedRecordsMixin, attrs:
  otherResumes: embedded: 'always'

`export default ResumeSerializer`
