`import Ember from 'ember'`

ResumesIndexResumeController = Ember.Controller.extend
  needs: ['resumes/index']

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


`export default ResumesIndexResumeController`
