`import DS from 'ember-data'`

Resume = DS.Model.extend
  primaryEmail: DS.attr('string')
  filename: DS.attr('string')
  firstName: DS.attr('string')
  lastName: DS.attr('string')
  address1: DS.attr('string')
  address2: DS.attr('string')
  city: DS.attr('string')
  state: DS.attr('string')
  zip: DS.attr('string')
  location: DS.attr()
  homePhone: DS.attr('string')
  mobilePhone: DS.attr('string')
  doctype: DS.attr('string')
  notes: DS.attr('string')
  created_at: DS.attr('date')
  updated_at: DS.attr('date')
  distance: DS.attr('number')
  otherResumes: DS.hasMany('other_resumes')

  fullName: ( ->
    @get('firstName') + ' ' + @get('lastName')
  ).property('firstName', 'lastName')

  title: ( ->
    @get('fullName')
  ).property('fullName')

  resumeTextUrl: ( ->
    adapterfor = @store.adapterFor('application')
    host = document.location.host.replace(/\:4200/,':3000')
    namespace = adapterfor.namespace
    'http://' + host + '/' + namespace + '/resumes/textfiles/' + @get('id')
  ).property('id')

  resumesOnFile: ( ->
    @get('otherResumes').length
  ).property('otherResumes')

  lat: ( ->
    @get('location')[1]
  ).property('location')
  lng: ( ->
    @get('location')[0]
  ).property('location')

  resumeUploadUrl: ( ->
    adapterfor = @store.adapterFor('application')
    host = document.location.host.replace(/\:4200/,':3000')
    namespace = adapterfor.namespace
    'http://' + host + '/' + namespace + '/resumes/' + @get('id') +
    '/resume_content'
  ).property('id')

`export default Resume`
