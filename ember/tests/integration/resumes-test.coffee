`import Ember from 'ember'`
`import startApp from '../helpers/start-app'`
`import Pretender from 'pretender'`

App = undefined
server = undefined

describe 'Integration - Resumes Page', ->
  beforeEach ->
    App = startApp()
    resumes = [
      {
        id: 1
        lastName: "Roberts"
        firstName: "Dread"
        state: "NY"
      },
      {
        id: 2
        lastName: "Coyote"
        firstName: "Wile E"
        state: "NY"
      }
      {
        id: 3
        lastName: "Sam"
        firstName: "Yosemite"
        state: "NY"
      }
    ]
    server = new Pretender ->
      @get '/api/v1/resumes', (request) ->
        if request.queryParams.state == 'NY'
          [200, {"Content-Type": "application/json"}, JSON.stringify {resumes: resumes}]
        else
          [200, {"Content-Type": "application/json"}, JSON.stringify {resumes: {}}]

      @get '/api/v1/resumes/:id', (request) ->
        resume = resumes.find ((resume) ->
          if resume.id == parseInt(request.params.id, 10)
            return resume
          return
        )
        [
          200
          { 'Content-Type': 'application/json' }
          JSON.stringify(resume: resume)
        ]
    return

  afterEach ->
    Ember.run(App, 'destroy')
    return

  it 'Should allow navigation to the resumes page', ->
    visit('/').then ->
      click('a:contains("Job Search")').then ->
        expect(find('h4').text()).to.include "Candidates"

  it 'Should require at least one parameter', ->
    this.timeout(9000)
    visit('/').then ->
      click('a:contains("Job Search")').then ->
        click('a:contains("Search Now")').then ->
          expect(find('.alert.alert-warning').text()).to.match /at least one/

  it 'Should list all resumes', ->
    this.timeout(9000)
    visit('/resumes?state=NY').then ->
      expect(find('.resume_list a').text()).to.include "Roberts"
      expect(find('.resume_list a').text()).to.include "Coyote"
      expect(find('.resume_list a').text()).to.include "Sam"

  it 'should clear the search when clicking reset', ->
    this.timeout(9000)
    visit('/resumes?state=NY')
    click('a:contains("Search Now")').then ->
      expect(find('.resume_list a').text()).to.include "Roberts"
    click('button:contains("Reset")').then ->
      click('a:contains("Search Now")').then ->
        expect(find('.resume_list a').text()).not.to.include "Roberts"


