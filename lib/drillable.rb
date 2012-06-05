require 'fastercsv'

# == Drillable
#
# Common methods and attributes for drilling down patients aggregated in Cohort
# Reports from BART1 and BART2
#
module Drillable
      
  LIST_CLASSES  = ['PatientProgram', 'PatientState', 'PatientRegistrationDate']
  MIN_DATE      = '1900-01-01'
  attr_accessor :output
  #attr_reader   :start_reasons, :regimens
  
  def initialize(start_date=MIN_DATE, end_date=Date.today, output=nil)
    @output = output
    super start_date, end_date
  end
  
  def unknown_age
    self.total_registered - (self.adults +
                             self.infants +
                             self.children)
  end
  
  def unknown_or_other_reason_outside_guidelines
    self.total_registered - (self.presumed_severe_hiv_disease_in_infants +
                             self.confirmed_HIV_infection_in_infants +
                             self.who_stage_1_or_2_CD4_below_threshold +
                             self.who_stage_2_total_lymphocytes_less_than_1200_per_mm3 +
                             self.who_stage_3 +
                             self.who_stage_4 +
                             self.breastfeeding_mothers +
                             self.pregnant +
                             self.children_12_to_23_months)
  end
  
  def no_tb
    self.total_registered - (self.tb_within_the_last_2_years.collect{|s| s.to_i } +
                             self.current_episode_of_tb.collect{|s| s.to_i })
  end
  
  def unknown_outcome
    self.total_registered - (self.total_alive_and_on_art +
                             self.died_total +
                             self.defaulted +
                             self.stopped_taking_arvs +
                             self.transferred_out_patients)
  end
  
  def unknown_tb_status
    self.total_alive_and_on_art - (self.tb_not_suspected +
                                   self.tb_suspected +
                                   self.tb_confirmed_currently_not_yet_on_tb_treatment +
                                   self.tb_confirmed_on_tb_treatment)
  end
  
  def non_standard_regimen
    self.total_alive_and_on_art - (self.arv_regimens('1A') +
                                   self.arv_regimens('1P') +
                                   self.arv_regimens('2A') +
                                   self.arv_regimens('2P') +
                                   self.arv_regimens('3A') +
                                   self.arv_regimens('3P') +
                                   self.arv_regimens('4A') +
                                   self.arv_regimens('4P') +
                                   self.arv_regimens('5A') +
                                   self.arv_regimens('6A') +
                                   self.arv_regimens('7A') +
                                   self.arv_regimens('8A') +
                                   self.arv_regimens('9P'))
  end
     
  def method_missing(method, *args)
    if method.to_s.starts_with? 'dump_'
      cohort_method = method.to_s.sub 'dump_', ''
      ids = []
      
      if self.methods.include? cohort_method
        ids = self.send(cohort_method, *args)
      end
      
      dump ids, @output
      
      ids.length
    else
      raise "method not supported: '#{method}'"
    end
  end
  
private
  
  # Print the list of patient ids to screen or <tt>output</tt> file
  def dump(ids, path)
    puts "Dumping #{ids.length} patients ..." if ids.length > 0
    if LIST_CLASSES.include? ids.first.class.to_s and 
       ids.first.attributes.keys.include?('patient_id')
      ids = ids.map(&:patient_id) 
    end
    
    if path.blank?
      ids.each{|id| puts id}
    else  
      FasterCSV.open(path, 'w') do |csv|
        ids.each{|id| csv << [id.to_s] }
      end
    end
  end
  
end
