`import Ember from 'ember'`

AlertController = Ember.Controller.extend
  alert: false
  observeAlert: ( ->
    if @.alert != false
      Ember.$('#flash').addClass('alert alert-' + @.alert[0] + ' alert-dismissable')
      Ember.$('#flash span.type strong').text(@.alert[0])
      Ember.$('#flash span.message').text(@.alert[1])
      Ember.$('#flash').fadeIn()
    else
      Ember.$('#flash').hide()

  ).observes('alert')

`export default AlertController`
