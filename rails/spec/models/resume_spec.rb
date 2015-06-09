require 'rails_helper'

describe Resume do
  it "should have a factory" do
    expect(FactoryGirl.build(:resume)).to be_valid
  end
end
