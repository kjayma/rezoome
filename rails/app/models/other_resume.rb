class OtherResume
  include Mongoid::Document
  include Mongoid::Timestamps
  embedded_in :resume

  field :resume_grid_fs_id, type: String
  field :doctype, type: String
  field :filename, type: String
  field :resume_text, type: String
  field :md5sum, type: String
  field :last_update, type: Time
end
