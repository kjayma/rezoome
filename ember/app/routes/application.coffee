`import Ember from 'ember'`

ApplicationRoute = Ember.Route.extend
  actions:
    showModal: (name, model) ->
      @render(name,
        into: 'application'
        outlet: 'modal'
        model: model
      )

`export default ApplicationRoute`
