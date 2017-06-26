`import Ember from 'ember'`

EqToHelper = Ember.Handlebars.makeBoundHelper (v1, v2) ->
  v1 == v2

`export default EqToHelper`
