`import DS from 'ember-data'`

Ember.Route.extend ->
  model: ->
    return this.store.find('resume')
