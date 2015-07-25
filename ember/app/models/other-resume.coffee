`import DS from 'ember-data'`

OtherResume = DS.Model.extend
  lastUpdate: DS.attr('date')
  resumeText: DS.attr('string')
  resumeGridFsId: DS.attr('string')
  resume: DS.belongsTo('Resume')
  doctype: DS.attr('string')
  filename: DS.attr('string')
  resumeFileUrl: ( ->
    adapterfor = @store.adapterFor('application')
    host = document.location.host.replace(/\:4200/,':3000')
    namespace = adapterfor.namespace
    'http://' + host + '/' + namespace + '/resumes/files/' + @get('resumeGridFsId') + '?filename=' + @get('filename') + '&extension=' + @get('doctype')
  ).property('resumeGridFsId')
`export default OtherResume`
