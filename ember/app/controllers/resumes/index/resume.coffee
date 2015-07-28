`import Ember from 'ember'`

ResumesIndexResumeController = Ember.Controller.extend
  # needs resume index for search terms
  needs: ['resumes/index']
  upload_button: "Upload New Resume"

  other_resumes: (->
    Ember.ArrayProxy.createWithMixins Ember.SortableMixin,
      sortAscending: false
      sortProperties: ['lastUpdate']
      content: @.get('model.otherResumes')
  ).property('model')

  search_terms: (->
    resumes_index_controller = @get('controllers.resumes/index')
    resumes_index_controller.get('search_term')
  ).property('model')

  actions:
    uploadStarted: (filename) ->
      @set('upload_button', 'Uploading ' + filename + ' ...')

    uploadFailed: ->
      Ember.get(this, 'flashMessages').clearMessages()
      Ember.get(this, 'flashMessages').danger("Error: the resume could not be uploaded.")
      @set('upload_button', 'Upload New Resume')

    uploadSucceeded: ->
      Ember.get(this, 'flashMessages').clearMessages()
      Ember.get(this, 'flashMessages').success("The resume was successfully uploaded")
      @set('upload_button', 'Upload New Resume')
      @get('model').reload()

    destroyOtherResume: (otherResume) ->
      console.log('in controller destroy other resume')
      resume = @get('model')
      resume.get('otherResumes').removeObject(otherResume)

      adapterfor = @store.adapterFor('application')
      host = document.location.host.replace(/\:4200/,':3000')
      #namespace = adapterfor.namespace
      url = 'http://' + host + '/api/v1' + '/resumes/' + resume.id + '/other_resumes/' + otherResume.id
      jQuery.ajax(url, method: "DELETE")

    submit: ->
      self = @
      @get('model').save().then(self.alertSuccess(@get('model'),self)).fail(self.alertFail)

  alertSuccess: (model) ->
    message = 'saved changes to ' + model.get('fullName') + "'s profile"
    Ember.get(this, 'flashMessages').clearMessages()
    Ember.get(this, 'flashMessages').success(message)

  alertFail: (reason, self) ->
    Ember.get(self, 'flashMessages').clearMessages()
    Ember.get(self, 'flashMessages').danger("Error: the profile could not be saved: " + reason)


`export default ResumesIndexResumeController`
