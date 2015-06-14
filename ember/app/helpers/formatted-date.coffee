`import Ember from 'ember'`

FormattedDateHelper = Ember.Handlebars.makeBoundHelper (date, format) ->
  moment(date).format(format)

`export default FormattedDateHelper`
