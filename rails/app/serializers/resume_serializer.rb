class ResumeSerializer < ActiveModel::Serializer
  attributes \
    :id,
    :md5sum,
    :primary_email,
    :filename,
    :first_name,
    :last_name,
    :position,
    :last_update,
    :address1,
    :address2,
    :city,
    :state,
    :zip,
    :home_phone,
    :mobile_phone,
    :doctype,
    :notes,
    :location,
    :distance,
    :other_resumes,

    :resume_grid_fs_id,
    #:resume_text,
    :created_at,
    :updated_at
end
