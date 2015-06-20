class Resume
  include Mongoid::Document
  include Mongoid::Timestamps

  embeds_many :other_resumes

  attr_accessor :distance

  field :md5sum, type: String
  field :primary_email, type: String
  field :filename, type: String
  field :last_update, type: Time
  field :first_name, type: String
  field :last_name, type: String
  field :address1, type: String
  field :address2, type: String
  field :city,  type: String
  field :state, type: String
  field :zip, type: String
  field :home_phone, type: String
  field :mobile_phone, type: String
  field :doctype, type: String
  field :notes, type: String

  field :resume_grid_fs_id, type: String
  field :resume_text, type: String
  field :location, type: Array

  index({ primary_email: 1}, { unique: true })
  index({ md5sum: 1}, { unique: true })
  index({ state: 1})
  index({ last_name: 1})
  index({ zip: 1})
  index({ location: "2dsphere" })
end
