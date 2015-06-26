`import DS from 'ember-data'`

OtherResume = DS.Model.extend
  lastUpdate: DS.attr('date')
  resumeText: DS.attr('string')
  resume: DS.belongsTo('Resume')
  resumeFileUrl: ( ->
    adapterfor = @store.adapterFor('application')
    host = document.location.host.replace(/\:4200/,':3000')
    namespace = adapterfor.namespace
    'http://' + host + '/' + namespace + '/resumes/files/' + @get('resume_grid_fs_id') + '?filename=' + @get('resume').get('fullName') + '.' + @get('resume').get('doctype')
  ).property('resume_grid_fs_id','resume')
`export default OtherResume`
