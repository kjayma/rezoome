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
    messages = ""
    reason.errors.forEach (item) ->
      messages += item.details
      return
    console.log(messages)
    flashMessages.danger("Error: the profile could not be saved: " + messages)

`export default PeopleNew`
