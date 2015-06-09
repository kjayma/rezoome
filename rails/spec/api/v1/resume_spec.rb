require "rails_helper"

describe API::V1::Resumes do
  let!(:resume1) { FactoryGirl.create(:resume) }
  let!(:resume2) { FactoryGirl.create(:resume, :resume_text => "Vascular") }
  let!(:resume3) { FactoryGirl.create(:resume, :resume_text => %Q[
        I'm a great gal with Cardiovascular experience and I worked for
        Medtronic, and I am a sales rep.
        You should hire me immediately!
    ],
    :state => 'NY'
  ) }

  describe "GET /api/v1/resume"
    it "will retrieve 1 resume for a single id" do
      get "/api/v1/resumes/#{resume1.id}"
      expect(response.status).to eql 200
      results = JSON.parse(response.body)
      expect(results['resume']['id']['$oid']).to eql resume1.id.to_s
    end

    it "will retrieve a resume when passed a search term found in resume_text" do
      get "/api/v1/resumes?search_term[]=cardiovascular"
      expect(response.status).to eql 200
      results = JSON.parse(response.body)
      expect(results['resume'].count).to eql 2
      expect(results['resume'][0]['id']['$oid']).to eql resume1.id.to_s
    end

    it "will retrieve a resume when passed multiple search terms found in resume_text using 'AND' logic" do
      get "/api/v1/resumes?#{{search_term: ['ev3','sales','cardiovascular']}.to_query}"
      expect(response.status).to eql 200
      results = JSON.parse(response.body)
      expect(results['resume'].count).to eql 1
      expect(results['resume'][0]['id']['$oid']).to eql resume1.id.to_s
    end

    it "will retrieve a resume by email" do
      get "/api/v1/resumes?primary_email=#{resume3.primary_email}"
      expect(response.status).to eql 200
      results = JSON.parse(response.body)
      expect(results['resume'].count).to eql 1
      expect(results['resume'][0]['primary_email']).to eql resume3.primary_email
    end

    it "will retrieve a resume by last_name" do
      get "/api/v1/resumes?last_name=#{resume3.last_name}"
      expect(response.status).to eql 200
      results = JSON.parse(response.body)
      expect(results['resume'].count).to eql 1
      expect(results['resume'][0]['last_name']).to eql resume3.last_name
    end

    it "will retrieve a resume by first_name" do
      get "/api/v1/resumes?first_name=#{resume3.first_name}"
      expect(response.status).to eql 200
      results = JSON.parse(response.body)
      expect(results['resume'].count).to eql 1
      expect(results['resume'][0]['first_name']).to eql resume3.first_name
    end

    it "will retrieve a resume by state" do
      get "/api/v1/resumes?state=#{resume3.state}"
      expect(response.status).to eql 200
      results = JSON.parse(response.body)
      expect(results['resume'].count).to eql 1
      expect(results['resume'][0]['state']).to eql resume3.state
    end
end
