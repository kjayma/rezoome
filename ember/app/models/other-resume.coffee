`import DS from 'ember-data'`

OtherResume = DS.Model.extend
  lastUpdate: DS.attr('date')
  resume: DS.belongsTo('resume', {async: true})

`export default OtherResume`
