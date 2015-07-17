require 'rails_helper'

describe "Resumes" do
  describe "update resume" do
    let!(:resume) { FactoryGirl.create(:resume) }
    let!(:resume_file) {
      Rack::Test::UploadedFile.new('spec/fixtures/docs/sample_resume.pdf', 'application/pdf')
    }


    before do
      post "/api/v1/resumes/resume_content", {
        id: resume.id,
        content: {
          content_type: resume_file.content_type,
          filename: resume_file.original_filename,
          file_data: Base64.encode64(resume_file.read)
        }
      }.to_json, "Content-Type" => "application/json"
    end

    it "returns the file" do
      expect(resume.other_resumes.count).to eql 3
    end
  end
end
