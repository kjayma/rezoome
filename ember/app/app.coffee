`import Ember from 'ember'`
`import Resolver from 'ember/resolver'`
`import loadInitializers from 'ember/load-initializers'`
`import config from './config/environment'`

Ember.MODEL_FACTORY_INJECTIONS = true

App = Ember.Application.extend
  LOG_TRANSITIONS: true
  LOG_TRANSITIONS_INTERNAL: true

  modulePrefix: config.modulePrefix
  podModulePrefix: config.podModulePrefix
  Resolver: Resolver
  name: "embeddedAdapter"

loadInitializers(App, config.modulePrefix)
App.register('serializer:_embedded',DS.EmbeddedSerializer)
App.register('adapter:_embedded',DS.EmbeddedAdapter)

`export default App`
