`import DS from 'ember-data'`

Resume = DS.Model.extend
  md5sum: DS.attr('string')
  primaryEmail: DS.attr('string')
  filename: DS.attr('string')
  firstName: DS.attr('string')
  lastName: DS.attr('string')
  lastUpdate: DS.attr('date')
  address1: DS.attr('string')
  address2: DS.attr('string')
  city: DS.attr('string')
  state: DS.attr('string')
  zip: DS.attr('string')
  homePhone: DS.attr('string')
  mobilePhone: DS.attr('string')
  doctype: DS.attr('string')
  notes: DS.attr('string')
  resume_grid_fs_id: DS.attr('')
  resume_text: DS.attr('string')
  created_at: DS.attr('date')
  updated_at: DS.attr('date')
  distance: DS.attr('number')
  otherResumes: DS.hasMany('other_resumes')
  fullName: ( ->
    @get('firstName') + ' ' + @get('lastName')
  ).property('firstName', 'lastName')
  resumeTextUrl: ( ->
    adapterfor = @store.adapterFor('application')
    host = document.location.host.replace(/\:4200/,':3000')
    namespace = adapterfor.namespace
    'http://' + host + '/' + namespace + '/resumes/textfiles/' + @get('id')
  ).property('id')
  resumeFileUrl: ( ->
    adapterfor = @store.adapterFor('application')
    host = document.location.host.replace(/\:4200/,':3000')
    namespace = adapterfor.namespace
    'http://' + host + '/' + namespace + '/resumes/files/' + @get('resume_grid_fs_id') + '?filename=' + @get('fullName') + '.' + @get('doctype')
  ).property('resume_grid_fs_id', 'fullName', 'doctype')
  resumesOnFile: ( ->
    @get('otherResumes').length
  ).property('otherResumes')

`export default Resume`
