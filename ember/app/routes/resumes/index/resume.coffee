`import Ember from 'ember'`

ResumesIndexResumeRoute = Ember.Route.extend
  zIndexCurrent: 0
  iconCurrent: ''

  afterModel: (resume) ->
    zIndexCurrent = resume.get('zIndex')
    iconCurrent   = resume.get('icon')
    resume.set('icon', {url: 'assets/images/green_marker.png'})
    resume.set('zIndex', 1000)

  actions:
    willTransition: (transition) ->
      resume = @controller.get('model')
      resume.set('icon', @iconCurrent)
      resume.set('zIndex', @zIndexCurrent)
      resume.set('isInfoWindowVisible', false)
      true

    putResume: (model) ->
      console.log('in put')
      model.save()

    destroyResume: (model) ->
      model.destroyRecord()

`export default ResumesIndexResumeRoute`
