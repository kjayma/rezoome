`import Ember from 'ember'`

FormComponent = Ember.Component.extend
  hasValidator: true
  actions:
    submit: (person) ->
      file = document.getElementById('file-field').files[0]
      person.set('content', file)
      person.set('filename', file.name)
      @sendAction('submit', person)

    reset: (person) ->
      @sendAction('reset', person)

`export default FormComponent`
