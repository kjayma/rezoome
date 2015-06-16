`import Ember from 'ember'`

DistanceInMilesHelper = Ember.Handlebars.makeBoundHelper (number) ->
  Math.round number * 3963.2

`export default DistanceInMilesHelper`
