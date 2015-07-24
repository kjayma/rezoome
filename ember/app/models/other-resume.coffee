`import DS from 'ember-data'`

OtherResume = DS.Model.extend
  lastUpdate: DS.attr('date')
  resumeText: DS.attr('string')
  resumeGridFsId: DS.attr('string')
  resume: DS.belongsTo('Resume')
  resumeFileUrl: ( ->
    adapterfor = @store.adapterFor('application')
    host = document.location.host.replace(/\:4200/,':3000')
    namespace = adapterfor.namespace
    'http://' + host + '/' + namespace + '/resumes/files/' + @get('resumeGridFsId') + '?filename=' + @get('resume.firstName') + '_' + @get('resume.lastName') + '.' + @get('resume').get('doctype')
  ).property('resumeGridFsId','resume')
`export default OtherResume`
