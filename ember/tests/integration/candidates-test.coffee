`import Ember from 'ember'`
`import startApp from '../helpers/start-app'`

App=undefined

describe 'Integration - Candidates', ->
  beforeEach ->
    App = startApp()
    return

  afterEach ->
    Ember.run(App, 'destroy')
    return

  it 'should visit the candidates page',  ->
    visit('/job_search/candidates').then ->
      expect(find('h4').text()).to.equal 'Search'
