`import Ember from 'ember'`

FormComponent = Ember.Component.extend
  actions:
    submit: (person) ->
      @sendAction('submit', person)

`export default FormComponent`
