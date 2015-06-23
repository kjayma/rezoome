`import DS from 'ember-data'`

Other = DS.Model.extend
  lastUpdate: DS.attr('date')
  resumeText: DS.attr('string')

`export default Other`
