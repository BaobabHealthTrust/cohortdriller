
class BART < Reports::CohortByRegistrationDate

  include Drillable
  
  attr :cached_start_reasons
    
  alias :total_registered              :patients_started_on_arv_therapy
  alias :patients_reinitiated_on_art   :re_initiated_patients
  alias :patients_transferred_in_on_art :transfer_ins_started_on_arv_therapy
  
  alias :male             :men_started_on_arv_therapy
  alias :pregnant_females :pregnant_women
  
  alias :infants
        :infants_started_on_arv_therapy
  alias :children
        :children_started_on_arv_therapy
  alias :adults
        :adults_started_on_arv_therapy
        
  alias :transferred_out :transferred_out_patients
  
  alias :total_patients_with_side_effects :side_effect_patients
  alias :patients_with_0_to_6_doses_missed_at_their_last_visit
        :adherent_patients
  alias :patients_with_7_plus_doses_missed_at_their_last_visit
        :over_adherent_patients
        
  alias :tb_not_suspected :tb_not_suspected_patients
  alias :tb_suspected     :tb_suspected_patients
  alias :tb_confirmed_not_yet_or_currently_not_on_tb_treatment 
        :tb_confirmed_on_treatment_patients
  alias :tb_confirmed_on_tb_treatment :tb_confirmed_not_on_treatment_patients
  
  def patients_initiated_on_art_first_time
    self.total_registered - self.patients_transfered_in_on_art
  end

  def non_pregnant_females
    self.women_started_on_arv_therapy - self.pregnant_females
  end
  
  # Start Reasons
  def presumed_severe_hiv_disease_in_infants
    self.patients_with_start_reason 'Presumed HIV Disease'
  end
  
  def confirmed_HIV_infection_in_infants
    self.patients_with_start_reason 'PCR Test'
  end
  
  def who_stage_1_or_2_CD4_below_threshold
    self.patients_with_start_reason 'who_stage_1_or_2_cd4'
  end
  
  def who_stage_2_total_lymphocytes_less_than_1200_per_mm3
    self.patients_with_start_reason(
         'Lymphocyte count below threshold with WHO stage 2')
  end
  
  def who_stage_3
    self.patients_with_start_reasons 'WHO stage 3'
  end
  
  def who_stage_4
    self.patients_with_start_reasons 'WHO stage 4'
  end
  
  def breastfeeding_mothers
    self.patients_with_start_reasons 'Breastfeeding'
  end
  
  def pregnant
    self.patients_with_start_reasons 'Pregnant'
  end
  
  def children_12_to_23_months
    self.patients_with_start_reasons 'Child HIV Positive'
  end
  
  
  # Stage defining conditions at ART initiation
  
  def current_episode_of_tb
    self.patients_with_start_cause 'start_cause_current_tb'
  end
  
  
  # Primary Outcomes
  
  def total_alive_and_on_art
    self.patients_with_outcomes 'On ART'
  end
  
  def died_within_the_1st_month_of_art_initiation
    self.find_all_dead_patients 'died_1st_month'
  end
  
  def died_within_the_2nd_month_after_art_initiation
    self.find_all_dead_patients 'died_2nd_month'
  end
  
  def died_within_the_3rd_month_after_art_initiation
    self.find_all_dead_patients 'died_3rd_month'
  end
  
  def died_after_the_end_of_the_3rd_month__art_initiation
    self.find_all_dead_patients 'died_after_3rd_month'
  end
  
  def died_total
    self.patients_with_outcomes 'Died'
  end
  
  def defaulted
    self.patients_with_outcomes 'Defaulter'
  end
  
  def stopped_taking_arvs
    self.patients_with_outcomes 'ART Stop'
  end
  
  # regimen_category e.g. '1A' or 'non-standard'
  def arv_regimens(regimen_category)
    if regimen_category == 'non-standard'
      self.non_standard_regimen
    else
      self.regimen_type regimen_category
    end
  end
  
end
