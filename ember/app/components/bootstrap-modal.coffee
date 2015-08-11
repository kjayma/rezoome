`import Ember from 'ember'`

BootstrapModalComponent = Ember.Component.extend
  actions:
    willDestroyElement: ->
      @toggleProperty('isShowingConfirmation')

    ok: (model) ->
      @toggleProperty('isShowingConfirmation')
      @$('.modal').modal('hide')
      @sendAction('ok', model)
      return

    close: ->
      @toggleProperty('isShowingConfirmation')
      @$('.modal').modal('hide')


    show: ->
      @toggleProperty('isShowingConfirmation')
      Ember.$('.modal').modal()
      return

`export default BootstrapModalComponent`
