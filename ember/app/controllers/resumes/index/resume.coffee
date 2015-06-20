`import Ember from 'ember'`

ResumesIndexResumeController = Ember.Controller.extend
  actions:
    emailResume: ->
      email_to = @.get('email_to')
      email_subject = @.get('email_subject')
      email_body = @.get('email_body')
      attachment = @.get('model').get('resumeFileUrl')
      mail_string = 'mailto:' + email_to + '?subject=' + email_subject + '&body=' + email_body + '&attachment=' + attachment
      console.log(mail_string)
      window.location = mail_string

`export default ResumesIndexResumeController`
