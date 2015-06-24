`import DS from 'ember-data'`

OtherResume = DS.Model.extend
  lastUpdate: DS.attr('date')
  resumeText: DS.attr('string')

`export default OtherResume`
