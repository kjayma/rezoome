`import Ember from 'ember'`
`import startApp from '../helpers/start-app'`

App=undefined

describe 'Integration - Resumes', ->
  beforeEach ->
    App = startApp()
    return

  afterEach ->
    Ember.run(App, 'destroy')
    return

  it 'should visit the resumes page',  ->
    visit('/resumes').then ->
      expect(find('h5').text()).to.equal 'Results'
