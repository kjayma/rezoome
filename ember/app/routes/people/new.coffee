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
    reset: (person) ->
      person.destroyRecord();
      @store.createRecord('resume')
      @refresh()

    create: ->
      @flashMessages = Ember.get(@, 'flashMessages')
      @currentModel.save().then( @alertSuccess.bind(@), @alertFail.bind(@) )

  alertSuccess: (model) ->
    flashMessages = Ember.get(this, 'flashMessages')
    message = 'saved changes to ' + model.get('fullName') + "'s profile"
    flashMessages.clearMessages()
    flashMessages.success(message)

  alertFail: (reason) ->
    flashMessages = Ember.get(this, 'flashMessages')
    flashMessages.clearMessages()
    messages = "<h4>There was a problem</h4><ul><li>"
    messages += reason.errors.map( (item) ->
      item.details
    ).uniq().join('</li><li>')
    messages += "</li></ul>"
    flashMessages.danger( messages.htmlSafe() )

`export default PeopleNew`
