class ResumeSerializer < ActiveModel::Serializer
  attributes
    :id,
    :md5sum,
    :primary_email,
    :filename,
    :last_update,
    :first_name,
    :last_name,
    :address1,
    :address2,
    :city,
    :state,
    :zip,
    :home_phone,
    :mobile_phone,
    :doctype,
    :notes,

    :resume_grid_fs_id,
    :resume_text,
    :location,
    :created_at,
    :updated_at
end
