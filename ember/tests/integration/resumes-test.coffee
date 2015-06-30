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
      },
      {
        id: 2
        lastName: "Coyote"
        firstName: "Wile E"
      }
      {
        id: 3
        lastName: "Sam"
        firstName: "Yosemite"
      }
    ]
    server = new Pretender ->
      @get '/api/v1/resumes', (request) ->
        [200, {"Content-Type": "application/json"}, JSON.stringify {resumes: resumes}]

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
    visit('/resumes').then ->
      expect(false)

  it 'Should list all resumes', ->
    visit('/resumes?state=NY').then ->
      expect(find('a:contains("Robert")').length).to.equal 1
      expect(find('a:contains("Coyote")').length).to.equal 1
      expect(find('a:contains("Sam")').length).to.equal 1
