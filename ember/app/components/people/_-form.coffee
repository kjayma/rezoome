`import Ember from 'ember'`

_FormComponent = Ember.Component.extend
  actions:
    submit: (person) ->
      @sendAction('submit', person)

`export default _FormComponent`
