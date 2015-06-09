FactoryGirl.define do
  factory :resume do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    primary_email { Faker::Internet.email }
    resume_text %Q[
        I'm a great guy with Cardiovascular experience and I worked for
        covidien and EV3, and I am a sales rep and I was a market manager.
        You should hire me immediately!
    ]
    zip "02492"
  end
end
