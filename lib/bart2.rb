
class BART < Cohort

  include Drillable
  
  attr :start_reasons
    
  BART_VERSION = 2
  
  #total_registered
  #patients_initiated_on_art_first_time
  #patients_reinitiated_on_art
  
  #tb_within_the_last_2_yrs
  #current_episode_of_tb
  #kaposis_sarcoma
  
  #total_alive_and_on_art
  
  alias :patients_transferred_in_on_art :transferred_in_patients

  alias :pregnant_females     :pregnant_women
  alias :non_pregnant_females :non_pregnant_women
  
  alias :died_total           :total_number_of_dead_patients
  alias :defaulted            :art_defaulted_patients
  alias :stopped_taking_arvs  :art_stopped_patients
  alias :transferred_out      :transferred_out_patients
  
  alias :total_patients_with_side_effects :patients_with_side_effects

  
  def male
    self.total_registered_by_gender_age(@start_date, @end_date,'M')
  end
  
  def infants
    self.total_registered_by_gender_age(@start_date, @end_date, nil, 0, 731)
  end
  
  def children
    self.total_registered_by_gender_age(@start_date, @end_date, nil, 731, 5479)
  end
  
  def adults
    self.total_registered_by_gender_age(@start_date, @end_date,
                                        nil, 5479, 109500)
  end
  
  def presumed_severe_hiv_disease_in_infants
    self.patients_with_start_reasons 'presumed'
  end
  
  def confirmed_HIV_infection_in_infants
    self.patients_with_start_reasons 'confirmed'
  end
  
  def who_stage_1_or_2_CD4_below_threshold
    self.patients_with_start_reasons ['WHO Stage I ', 'cd']
  end
  
  def who_stage_2_total_lymphocytes_less_than_1200_per_mm3
    self.patients_with_start_reasons ['WHO Stage II ', 'Lymphocyte']
  end
  
  def who_stage_3
    self.patients_with_start_reasons 'WHO Stage III '
  end
  
  def who_stage_4
    self.patients_with_start_reasons 'WHO Stage IV '
  end
  
  def breastfeeding_mothers
    self.patients_with_start_reasons 'Breastfeeding'
  end

  def pregnant
    self.patients_with_start_reasons 'Pregnant'
  end
  
  def children_12_to_23_months
    self.patients_with_start_reasons 'HIV infected'
  end
  
  def died_within_the_1st_month_of_art_initiation
    self.total_number_of_died_within_range(0, 29)
  end
  
  def died_within_the_2nd_month_of_art_initiation
    self.total_number_of_died_within_range(29, 57)
  end
  
  def died_within_the_3rd_month_of_art_initiation
    self.total_number_of_died_within_range(57, 85)
  end
  
  def died_after_the_3rd_month_of_art_initiation
    self.total_number_of_died_within_range(85, 1000000)
  end
  
  
  
  def tb_not_suspected
    @cached_tb_status ||= self.tb_status 
    @cached_tb_status['TB STATUS']['Not Suspected']
  end

  def tb_suspected
    @cached_tb_status ||= self.tb_status 
    @cached_tb_status['TB STATUS']['Suspected']
  end
  
  def tb_confirmed_not_yet_or_currently_not_on_tb_treatment
    @cached_tb_status ||= self.tb_status 
    @cached_tb_status['TB STATUS']['Not on treatment']
  end
  
  def tb_confirmed_on_tb_treatment
    @cached_tb_status ||= self.tb_status 
    @cached_tb_status['TB STATUS']['On Treatment']
  end
  
#private    
  # Pull out patients under a the given indicator
  def patients_with_start_reasons(values=nil)
    if values
      values = [values] unless values.is_a? Array
      @start_reasons ||= self.start_reason
      @start_reasons.map do |r|
        next if r.name.blank?
        id = nil
        values.each do |v|
          if r.name.downcase.match(v.downcase)
            id = r.patient_id
            break
          end
        end
        id
      end.compact
    end
  end

end
