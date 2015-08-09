`import Ember from 'ember'`

FormComponent = Ember.Component.extend
  hasValidator: true
  actions:
    submit: (person) ->
      console.log('content' + @get('content'))
      @sendAction('submit', person)

    reset: (person) ->
      @sendAction('reset', person)

`export default FormComponent`
