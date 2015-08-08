`import Ember from 'ember'`

PeopleNew = Ember.Route.extend

  model: ->
    @store.createRecord('resume')

  isNew: true

  flashMessages: ""

  deactivate: ->
    model = @modelFor('people.new')
    if (model && model.get('isNew') && !model.get('isSaving'))
      model.destroyRecord()

  actions:
    create: ->
      @flashMessages = Ember.get(@, 'flashMessages')
      @currentModel.save().then( @alertSuccess, @alertFail.bind(@) )

  alertSuccess: (model) ->
    flashMessages = Ember.get(this, 'flashMessages')
    message = 'saved changes to ' + model.get('fullName') + "'s profile"
    flashMessages.clearMessages()
    flashMessages.success(message)

  alertFail: (reason) ->
    flashMessages = Ember.get(this, 'flashMessages')
    flashMessages.clearMessages()
    messages = "<h4>There was a problem</h4><ul>"
    reason.errors.forEach (item) ->
      messages += "<li>" + item.details + "</li>"
      return
    messages += "</ul>"
    flashMessages.danger( messages.htmlSafe() )

`export default PeopleNew`
