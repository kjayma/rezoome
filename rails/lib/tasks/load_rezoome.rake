require 'digest'
require 'mongoid/grid_fs'
require 'yomu'
require 'geokit'

logger = Logger.new("log/rezoome_load.log")
namespace :load do
  include Geokit::Geocoders

	desc "load resumes"
	task :resumes, [:resume_directory] => :environment do |t, args|
    filecount = 0
    resumes = Dir.glob(File.join(args[:resume_directory], "**", "*.*"))
    logger.info resumes.count
    resumes.each do |resume|
      p resume
      logger.info resume
      md5sum = Digest::MD5.hexdigest File.read(resume)


      unless Resume.find_by(md5sum: md5sum)
        resume_text = Yomu.new(resume).text

        create_or_update(resume, resume_text, md5sum)
      end
      filecount +=1
    end
    logger.info "processed #{filecount} files"
	end

  desc "geocoding"
  task :geocode => :environment do
    Resume.all.each do |resume|
      if !resume.location
        loc = MultiGeocoder.geocode("#{resume.address1}, #{resume.city}, #{resume.state} #{resume.zip}")
        unless loc.success
          loc = MultiGeocoder.geocode(resume.zip)
        end
        resume.update_attributes(location: [loc.lng, loc.lat]) if loc.success
      end
    end
  end

  desc "update other resumes by adding parent resume"
  task :update_other_resumes => :environment do
    Resume.all.each do |resume|
      logger.info(resume.filename)
      md5s = resume.other_resumes.collect(&:md5sum)
      unless md5s.include? resume.md5sum
        resume.other_resumes.create!(
          resume_text: resume.resume_text,
          md5sum: resume.md5sum,
          last_update: resume.last_update,
          resume_grid_fs_id: resume.resume_grid_fs_id
        )
      end
      resume.unset('md5sum') if resume.md5sum
      resume.unset('resume_text') if resume.resume_text
      resume.unset('resume_grid_fs_id') if resume.resume_grid_fs_id
      resume.unset('last_update') if resume.last_update
      resume.save!
    end
  end

  desc "Fix states"
  task :fix_states => :environment do
    Resume.all.each do |resume|
      fix_state(resume) if resume.state
    end
  end

  private

  def create_or_update(resume, resume_text, md5sum)
    resume_data = decoded_filename(resume)
    if duplicate_resume = Resume.find_by(primary_email: primary_email(resume_text))
      unless duplicate_resume.other_resumes.collect(&:md5sum).include? md5sum
        duplicate_resume.other_resumes.create(
          resume_grid_fs_id: grid_file_id(resume),
          resume_text:       resume_text,
          md5sum:            md5sum,
          last_update:       File.mtime(resume)
        )
      end
      return
    end

    address = address(resume_text)

    Resume.create(
      filename:           resume,
      first_name:         resume_data[:first_name],
      last_name:          resume_data[:last_name],
      address1:           address[:address1],
      city:               address[:city] || resume_data[:city],
      state:              address[:state],
      zip:                address[:zip],
      location:           address[:location],
      primary_email:      primary_email(resume_text),
      doctype:            resume_data[:doctype],
      resume_grid_fs_id:  grid_file_id(resume),
      resume_text:        resume_text,
      md5sum:             md5sum,
      last_update:        File.mtime(resume)
    )
  end

  def decoded_filename(filename)
    return {} unless filename
    filename_info = filename.match(/(?:(?:.*\/)*)(.*), *(\w*)(?:\w* *)* +(\w*)\./)
    return {} unless filename_info
    resume_data = {}
    resume_data[:last_name]     = filename_info[1].humanize if filename_info[1]
    resume_data[:first_name]    = filename_info[2].humanize if filename_info[2]
    resume_data[:city]          = filename_info[3].humanize if filename_info[3]
    doctype                     = filename.match(/\.(.*)/)
    resume_data[:doctype]       = doctype[1] if doctype[1]
    resume_data
  end

  def grid_file_id(filename)
    grid_fs = Mongoid::GridFs
    file    = File.open(filename)
    grid_fs.put(file.path).id
  end

  def address(full_text)
    zip_regex_pre           = / +(\d{5}(?:[-\s]\d{4})?)/
    zip_regex               = /(?<![Bb]ox)#{zip_regex_pre}/
    state_regex             = /(\w+)#{zip_regex}/
    delimiters              = /[\n,\*•♦ ]/
    city_regex              = /#{delimiters}* *([\w \-\']*)[, ] *#{state_regex}/
    city_no_zip_regex       = /#{delimiters}* *([\w \-\']*), *(#{states.join('|')})/
    address_no_zip_regex    = /#{delimiters}* *(\w* *\d+[\w\-\d ]*)#{city_no_zip_regex}/

    address_hash            = {}

    result                  = full_text.match(zip_regex)
    address_hash[:zip]      = zip = result ? result[1] : nil

    if address_hash[:zip]
      result                  = full_text.match(state_regex)
      address_hash[:state]    = state = result ? result[1] : nil

      result                  = full_text.match(city_regex)
      address_hash[:city]     = city = result ? result[1] : nil

      address_regex           = /[\n,\*•♦ ]* *(\w* *\d+[\w\-\d ]*)#{delimiters}*#{city}.*#{state}.*#{zip}/
      result                  = full_text.match(address_regex)
      address_hash[:address1] = result ? result[1] : nil
    else
      result                  = full_text.match(city_no_zip_regex)
      address_hash[:city]     = city  = result ? result[1] : nil
      address_hash[:state]    = state = result ? result[2] : nil

      address_no_zip_regex    = /[\n,\*•♦ ]* *(\w* *\d+[\w\-\d ]*)#{delimiters}*#{city}.*#{state}/
      result                  = full_text.match(address_no_zip_regex)
      address_hash[:address1] = result ? result[1] : nil

      if address_hash[:address1] && city && state
        loc = MultiGeocoder.geocode("#{address_hash[:address1]}, #{city}, #{state}")
        address_hash[:zip] = loc.zip
        address_hash[:location] = [loc.lng, loc.lat] if loc.success
      end
    end

    #if !loc
    #  loc = MultiGeocoder.geocode("#{address_hash[:address1]}, #{city}, #{state}")
    #  unless loc.success
    #    loc = MultiGeocoder.geocode(address_hash[:zip])
    #  end
    #end

    # address_hash[:location] = [loc.lng, loc.lat] if loc.success

    if address_hash[:state]
      if address_hash[:state].length > 2
        state = states.detect{ |st| st[1].upcase == address_hash[:state].upcase }
        address_hash[:state] = state[0] if state
      else
        address_hash[:state] = address_hash[:state].upcase
      end
    end

    address_hash
  end

  def primary_email(full_text)
    result = full_text.match(/(\b[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}\b)/i)
    result[1] if result
  end

  def fix_state(resume)
    state = resume.state
    return if states.detect{ |abbr, name| abbr == state}
    if state.length == 2
      if fixed_state = states.detect{ |abbr, name| abbr == state.upcase}
        resume.state = resume.state.upcase
      else
        resume.state = nil
      end
    else
      if fixed_state = states.detect{ |abbr, name| name.upcase == state.upcase}
        resume.state = fixed_state[0]
      else
        resume.state = nil
      end
    end
    resume.save
  end

  def states
    return Array[
      ["AK", "Alaska"],
      ["AL", "Alabama"],
      ["AR", "Arkansas"],
      ["AS", "American Samoa"],
      ["AZ", "Arizona"],
      ["CA", "California"],
      ["CO", "Colorado"],
      ["CT", "Connecticut"],
      ["DC", "District of Columbia"],
      ["DE", "Delaware"],
      ["FL", "Florida"],
      ["GA", "Georgia"],
      ["GU", "Guam"],
      ["HI", "Hawaii"],
      ["IA", "Iowa"],
      ["ID", "Idaho"],
      ["IL", "Illinois"],
      ["IN", "Indiana"],
      ["KS", "Kansas"],
      ["KY", "Kentucky"],
      ["LA", "Louisiana"],
      ["MA", "Massachusetts"],
      ["MD", "Maryland"],
      ["ME", "Maine"],
      ["MI", "Michigan"],
      ["MN", "Minnesota"],
      ["MO", "Missouri"],
      ["MS", "Mississippi"],
      ["MT", "Montana"],
      ["NC", "North Carolina"],
      ["ND", "North Dakota"],
      ["NE", "Nebraska"],
      ["NH", "New Hampshire"],
      ["NJ", "New Jersey"],
      ["NM", "New Mexico"],
      ["NV", "Nevada"],
      ["NY", "New York"],
      ["OH", "Ohio"],
      ["OK", "Oklahoma"],
      ["OR", "Oregon"],
      ["PA", "Pennsylvania"],
      ["PR", "Puerto Rico"],
      ["RI", "Rhode Island"],
      ["SC", "South Carolina"],
      ["SD", "South Dakota"],
      ["TN", "Tennessee"],
      ["TX", "Texas"],
      ["UT", "Utah"],
      ["VA", "Virginia"],
      ["VI", "Virgin Islands"],
      ["VT", "Vermont"],
      ["WA", "Washington"],
      ["WI", "Wisconsin"],
      ["WV", "West Virginia"],
      ["WY", "Wyoming"]
    ]
  end
end
