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
      resume.save()

`export default ResumesIndexResumeController`
