`import Ember from 'ember'`

ResumesIndexResumeController = Ember.Controller.extend
  other_resumes: (->
    Ember.ArrayProxy.createWithMixins Ember.SortableMixin,
      sortAscending: false
      sortProperties: ['lastUpdate']
      content: @.get('model.otherResumes')
  ).property('model')

`export default ResumesIndexResumeController`
