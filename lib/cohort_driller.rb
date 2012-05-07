require 'fastercsv'
require 'drillable'

if File.exists? RAILS_ROOT + '/app/models/cohort.rb'
  require 'bart2'
else
  require 'bart1'
end

# == CohortDriller
#
# Drill down patients aggregated under cohort report indicators
#
# Example:
# 
# > cd = CohortDriller.new '1900-01-01', '2011-12-31', '/tmp/pat_ids.csv'
# > cd.dump_total_registered
# > exec 'cat /tmp/pat_ids.csv'
# > cd.dump_patients 'start_reason', 'WHO Stage II '
#

class CohortDriller < BART
 
end