`import DS from 'ember-data'`

ResumeSerializer = DS.ActiveModelSerializer.extend DS.EmbeddedRecordsMixin, attrs:
  others: embedded: 'always'

`export default ResumeSerializer`
