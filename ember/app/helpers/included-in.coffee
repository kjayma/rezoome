`import Ember from 'ember'`

IncludedInHelper = Ember.Handlebars.makeBoundHelper (params) ->
  items = params[0] || []
  value = params[1] 
  return items.indexOf(value) > -1 

`export default IncludedInHelper`
