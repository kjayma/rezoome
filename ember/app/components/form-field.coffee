`import Ember from 'ember'`

FormFieldComponent = Ember.Component.extend

  object: Ember.computed.alias 'parentView.model'

  hasError: (->
    @get('object.errors')?.has @get('property')
  ).property 'object.errors.[]'

  errors: (->
    return Em.A() unless @get('object.errors')
    @get('object.errors').errorsFor(@get('property')).mapBy('message').join(', ')
  ).property 'object.errors.[]'


  setupBindings: (->
    @binding?.disconnect @ # Disconnect old binding if present

    # Create a binding between the value property of the component,
    # and the correct field name on the model object.
    @binding = Ember.Binding.from("object.#{@get 'property'}").to('value')

    # Activate the binding
    @binding.connect @

  ).on('init').observes 'property', 'object'

  # Ensure the bindings are cleaned up when the component is removed
  tearDownBindings: (->
    @binding?.disconnect @
  ).on 'willDestroyElement'

`export default FormFieldComponent`
