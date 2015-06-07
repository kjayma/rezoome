require 'rails_helper'
require 'rake'

describe 'rake task' do
  before :all do
    Rake.application.rake_require "tasks/load_rezoome"
    Rake::Task.define_task(:environment)
  end

  describe 'load_resumes' do
    let!(:rails_root){ File.expand_path(File.dirname(__FILE__) + '/../../../') }
    let :run_rake_task do
      Rake::Task["load:resumes"].reenable
      Rake.application.invoke_task "load:resumes[#{rails_root}/tmp/resumes]"
    end
    let!(:resume){ "Bob Jones\n105 Magnolia Lane\nMobile, AL 38838 \n othere bob@yahoo.com suff 23383 fof" }

    context "with a resume in the tmp/resumes/alabama directory" do
      before do
        `mkdir #{rails_root}/tmp/resumes`
        `mkdir #{rails_root}/tmp/resumes/alabama`
        `echo "#{resume}" > "#{rails_root}/tmp/resumes/alabama/JONES, BOB MOBILE.doc"`
      end

      after do
        `rm -fr #{rails_root}/tmp/resumes`
      end

      it "contains a resume in the tmp/resumes/alabama directory" do
        expect(File).to exist("#{rails_root}/tmp/resumes/alabama/JONES, BOB MOBILE.doc")
      end

      it "only loads the resume once" do
        `echo "#{resume}" > "#{rails_root}/tmp/resumes/alabama/JONES, BOB MOBILE2.doc"`
        run_rake_task
        expect(Resume.all.count).to eql 1
      end

      it "extracts the filename" do
        run_rake_task
        expect(Resume.first.filename).to eql "#{rails_root}/tmp/resumes/alabama/JONES, BOB MOBILE.doc"
      end

      it "loads the name using the file name" do
        run_rake_task
        expect(Resume.first.first_name).to eql "Bob"
        expect(Resume.first.last_name).to eql "Jones"
      end

      it "extracts the time the resume was last_updated" do
        run_rake_task
        expect(Resume.first.last_update.utc.to_s).to eql File.mtime("#{rails_root}/tmp/resumes/alabama/JONES, BOB MOBILE.doc").utc.to_s
      end

      it "can display the file contents" do
        run_rake_task
        grid_fs = Mongoid::GridFs
        resume_contents = grid_fs.get(Resume.first.resume_grid_fs_id).data
        expect(resume_contents).to match resume
      end

      it "extracts the text from the file" do
        run_rake_task
        expect(Resume.first.resume_text).to match resume
      end

      describe "extracting zip code" do
        shared_examples "it extracts zip" do
          it "extracts zip" do
            run_rake_task
            expect(Resume.first.zip).to eql '38838'
          end
        end

        context "with a normal zip" do
          it_behaves_like "it extracts zip"
        end

        context "with some crap before the zip" do
          let!(:resume){ "yafasd12345-3949asdfasfaBob Jones\n105 Magnolia Lane\nMobile, AL 38838 \n othere suff 23383 fof" }

          it_behaves_like "it extracts zip"
        end

        context "with a PO Box before the zip" do
          let!(:resume){ "Bob Jones\nP.O. Box 90393\nMobile, AL 38838 \n othere suff 23383 fof" }

          it_behaves_like "it extracts zip"
        end

        context "with extraneous silliness, like asterisks, in the address" do
          let!(:resume){ "Bob Jones * 105 Magnolia Lane * Mobile, AL * 38838 *" }

          it_behaves_like "it extracts zip"
        end
      end

      shared_examples "it extracts address, city, and state" do
        it "extracts state" do
          run_rake_task
          expect(Resume.first.state).to eql 'AL'
        end

        it "extracts city" do
          run_rake_task
          expect(Resume.first.city).to eql 'Mobile'
        end

        it "extracts address" do
          run_rake_task
          expect(Resume.first.address1).to eql '105 Magnolia Lane'
        end

        context "with an address separated by commas only" do
          let!(:resume){ "Bob Jones, 10 Park Avenue, Suite 112, New York City, NY 11202\n othere bob@yahoo.com suff 23383 fof" }
          it "finds the city and address" do
            run_rake_task
            expect(Resume.first.city).to eql 'New York City'
            expect(Resume.first.address1).to eql 'Suite 112'
          end
        end
      end

      describe "city and state" do
        context "when zip exists" do
          it_behaves_like "it extracts address, city, and state"
        end

        context "when zip does not exist" do
          let!(:resume){ "Bob Jones\n105 Magnolia Lane\nMobile, Alabama\n" }

          it_behaves_like "it extracts address, city, and state"

          it "gets a zip from geocode" do
            run_rake_task
            expect(Resume.first.zip).to eql "36572"
          end
        end
      end

      it "extracts an email address" do
        run_rake_task
        expect(Resume.first.primary_email).to match "bob@yahoo.com"
      end

      context "with the same email address duplicated in two docs" do
        let!(:resume2){ "Bob Jones\n10 Park Avenue\nSuite 112\n New York, NY 11202\n othere bob@yahoo.com suff 23383 fof" }

        it "saves the second contents of the second resume under the first collection" do
          `echo "#{resume2}" > "#{rails_root}/tmp/resumes/alabama/JONES, BOB MOBILE2.doc"`
          run_rake_task
          grid_fs = Mongoid::GridFs
          expect(Resume.all.count).to eql 1
          expect(Resume.first.other_resumes.count).to eql 1
          expect(grid_fs.get(Resume.first.other_resumes.first.resume_grid_fs_id).data).to eql resume2+"\n"
          expect(Resume.first.other_resumes.first.last_update.utc.to_s).to eql File.mtime("#{rails_root}/tmp/resumes/alabama/JONES, BOB MOBILE2.doc").utc.to_s
        end
      end
    end
  end

  describe 'geocode' do
    let!(:rails_root){ File.expand_path(File.dirname(__FILE__) + '/../../../') }
    let :run_rake_task do
      Rake::Task["load:resumes"].reenable
      Rake.application.invoke_task "load:resumes[#{rails_root}/tmp/resumes]"
    end
    let!(:resume){ "Bob Jones\n105 Magnolia Lane\nMobile, AL 38838 \n othere bob@yahoo.com suff 23383 fof" }

    context "with a resume in the tmp/resumes/alabama directory" do
      before do
        `mkdir #{rails_root}/tmp/resumes`
        `mkdir #{rails_root}/tmp/resumes/alabama`
        `echo "#{resume}" > "#{rails_root}/tmp/resumes/alabama/JONES, BOB MOBILE.doc"`
      end

      after do
        `rm -fr #{rails_root}/tmp/resumes`
      end

      describe "geocoding" do
        shared_examples "it finds the lat" do
          it "finds the lat" do
            #pending
            #run_rake_task
            #expect(Resume.first.location[0]).not_to be nil
          end
        end

        context "the whole address is valid" do
          let!(:resume){ "Bob Jones\n105 Magnolia Lane\nMobile, Alabama\n" }

          it_behaves_like "it finds the lat"
        end

        context "the address is bad but the zipcode is good" do
          let!(:resume){ "Bob Jones\nadf akf39afha0hf aoadf\nMobile, Alabama 36572\n" }

          it_behaves_like "it finds the lat"
        end
      end
    end
  end
end
