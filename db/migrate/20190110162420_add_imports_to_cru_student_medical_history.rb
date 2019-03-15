class AddImportsToCruStudentMedicalHistory < ActiveRecord::Migration
  def change
    add_column :cru_student_medical_histories, :gsky_lunch, :string
    add_column :cru_student_medical_histories, :gsky_signout, :string
    add_column :cru_student_medical_histories, :gsky_sibling_signout, :string
    add_column :cru_student_medical_histories, :gsky_sibling, :string
    add_column :cru_student_medical_histories, :gsky_small_group_friend, :text
    add_column :cru_student_medical_histories, :gsky_musical, :string
    add_column :cru_student_medical_histories, :gsky_activities, :text
    add_column :cru_student_medical_histories, :gsky_gain, :text
    add_column :cru_student_medical_histories, :gsky_growth, :text
    add_column :cru_student_medical_histories, :gsky_addl_info, :text
    add_column :cru_student_medical_histories, :gsky_challenges, :string
    add_column :cru_student_medical_histories, :gsky_large_groups, :string
    add_column :cru_student_medical_histories, :gsky_small_groups, :string
    add_column :cru_student_medical_histories, :gsky_leader, :string
    add_column :cru_student_medical_histories, :gsky_follower, :string
    add_column :cru_student_medical_histories, :gsky_friends, :string
    add_column :cru_student_medical_histories, :gsky_hesitant, :string
    add_column :cru_student_medical_histories, :gsky_active, :string
    add_column :cru_student_medical_histories, :gsky_reserved, :string
    add_column :cru_student_medical_histories, :gsky_boundaries, :string
    add_column :cru_student_medical_histories, :gsky_authority, :string
    add_column :cru_student_medical_histories, :gsky_adapts, :string
    add_column :cru_student_medical_histories, :gsky_allergies, :string
    add_column :cru_student_medical_histories, :med_allergies, :string
    add_column :cru_student_medical_histories, :food_allergies, :string
    add_column :cru_student_medical_histories, :other_allergies, :string
    add_column :cru_student_medical_histories, :health_concerns, :string
    add_column :cru_student_medical_histories, :asthma, :string
    add_column :cru_student_medical_histories, :migraines, :string
    add_column :cru_student_medical_histories, :severe_allergy, :string
    add_column :cru_student_medical_histories, :anorexia, :string
    add_column :cru_student_medical_histories, :diabetes, :string
    add_column :cru_student_medical_histories, :altitude, :string
    add_column :cru_student_medical_histories, :concerns_misc, :string
    add_column :cru_student_medical_histories, :cs_health_misc, :string
    add_column :cru_student_medical_histories, :cs_vip_meds, :text
    add_column :cru_student_medical_histories, :cs_vip_dev, :text
    add_column :cru_student_medical_histories, :cs_vip_strengths, :text
    add_column :cru_student_medical_histories, :cs_vip_challenges, :text
    add_column :cru_student_medical_histories, :cs_vip_mobility, :text
    add_column :cru_student_medical_histories, :cs_vip_walk, :text
    add_column :cru_student_medical_histories, :cs_vip_comm, :string
    add_column :cru_student_medical_histories, :cs_vip_comm_addl, :text
    add_column :cru_student_medical_histories, :cs_vip_comm_small, :text
    add_column :cru_student_medical_histories, :cs_vip_comm_large, :text
    add_column :cru_student_medical_histories, :cs_vip_comm_directions, :text
    add_column :cru_student_medical_histories, :cs_vip_stress, :string
    add_column :cru_student_medical_histories, :cs_vip_stress_addl, :text
    add_column :cru_student_medical_histories, :cs_vip_stress_behavior, :text
    add_column :cru_student_medical_histories, :cs_vip_calm, :text
    add_column :cru_student_medical_histories, :cs_vip_sitting, :text
    add_column :cru_student_medical_histories, :cs_vip_hobby, :text
    add_column :cru_student_medical_histories, :cs_vip_buddy, :text
    add_column :cru_student_medical_histories, :cs_vip_addl_info, :text
  end
end