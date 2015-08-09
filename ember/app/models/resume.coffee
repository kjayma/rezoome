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
  content: DS.attr()

  fullName: ( ->
    @get('firstName') + ' ' + @get('lastName')
  ).property('firstName', 'lastName')

  title: ( ->
    @get('fullName')
  ).property('fullName')

  currentJob:
    Ember.computed 'otherResumes.resumeText', ->
      otherResumesSorted = Ember.ArrayProxy.createWithMixins Ember.SortableMixin,
        sortAscending: false
        sortProperties: ['lastUpdate']
        content: @get('otherResumes')
      latest_resume = otherResumesSorted.objectAt(0)
      latest_text = latest_resume.get('resumeText')
      job_regex = /^(.*)(\d{2}|[:\-–]|to)+ *([Pp]resent|Current)(.*)$/m
      match = job_regex.exec(latest_text)
      if match
        if !match[1] && !match[3]
          job_regex = /\n.*\n.*\n(.*)\d{4} +([:\-–]|to)(.*)$/m
          match = job_regex.exec(latest_text)
      else
        job_regex = /^(.*)[ \/\-–]\d{4} +([:\-–]|to)(.*)$/m
        match = job_regex.exec(latest_text)

      if match
        return match[0]

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
