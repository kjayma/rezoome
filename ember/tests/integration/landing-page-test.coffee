`import Ember from 'ember'`
`import startApp from '../helpers/start-app'`

App=undefined

describe 'Integration - Landing Page', ->
  beforeEach ->
    App = startApp()
    return

  afterEach ->
    Ember.run(App, 'destroy')
    return

  it 'should name the application as Rezoome',  ->
    visit('/').then ->
      expect(find('a.rezoome_header').text()).to.equal 'Rezoome'

  it 'should navigate to the People page', ->
    visit('/').then ->
      click('a:contains("People")').then ->
        expect(find('h3').text()).to.equal('People')

  it 'Should allow navigating back to root from another page', ->
    visit('/people').then ->
      click('a:contains("Rezoome")').then ->
        expect(find('h3').text()).to.not.equal('People')

  it 'should navigate to the Job Search page', ->
    visit('/resumes').then ->
      click('a:contains("Jobs")').then ->
        expect(find('h4').text()).to.contain('Jobs')

  it 'should navigate to the Jobs page', ->
    visit('/jobs').then ->
      click('a:contains("Jobs")').then ->
        expect(find('h3').text()).to.equal('Jobs')
