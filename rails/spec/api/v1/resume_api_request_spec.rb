require 'rails_helper'

describe "API::V1::Resumes" do
  describe "update resume" do
    let!(:resume) { FactoryGirl.create(:resume) }
    let!(:resume_file) {
      Rack::Test::UploadedFile.new('spec/fixtures/docs/sample_resume.pdf', 'application/pdf')
    }


    before do
      post "/api/v1/resumes/#{resume.id}/resume_content", {
        file: {
          head: resume_file.content_type,
          filename: resume_file.original_filename,
          name: 'file',
          tempfile: Base64.encode64(resume_file.read)
        }
      }
    end

    it "returns the file" do
      resume.reload
      expect(resume.other_resumes.count).to eql 3
    end
  end
end
