`import Ember from 'ember'`

ResumesIndexResumeController = Ember.Controller.extend
  actions:
    emailResume: ->
      email_to = @.get('email_to')
      email_subject = @.get('email_subject')
      email_body = @.get('email_body')
      attachment = @.get('model').get('resumeFileUrl')
      alert('this feature is not yet in service')

`export default ResumesIndexResumeController`
