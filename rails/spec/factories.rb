FactoryGirl.define do
  factory :resume, :class => Resume do
    resume_text "this is resume 1"
    md5sum "aakfjdkdfjw399484"
    last_update Time.now
    resume_grid_fs_id "adifidfds"
    other_resumes { [FactoryGirl.build( :other_resume2 ), FactoryGirl.build( :other_resume3 )]  }
  end

  factory :other_resume2, :class => OtherResume do
    resume_text "this is resume 2"
    md5sum "39dkf94949s"
  end

  factory :other_resume3, :class => OtherResume do
    resume_text "this is resume 3"
    md5sum "lkeiic8384582kakjf893"
  end
end
