# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{cohortdriller}
  s.version = "0.1.9"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.2") if s.respond_to? :required_rubygems_version=
  s.authors = ["Baobab Health"]
  s.date = %q{2012-06-21}
  s.description = %q{Drill down cohort patients}
  s.email = %q{developers@baobabhealth.org}
  s.extra_rdoc_files = ["README.rdoc", "lib/drillable.rb",
                        "lib/cohort_driller.rb"]
  s.files = [
             "lib/drillable.rb", "lib/cohort_driller.rb",
             "lib/bart1.rb", "lib/bart2.rb",
             "spec/cohort_driller_spec.rb", "spec/spec_helper.rb",
             "cohortdriller.gemspec"]
  s.homepage = %q{http://github.com/baobabhealthtrust/cohortdriller}
  s.rdoc_options = ["--line-numbers", "--inline-source", "--title", 
                    "CohortDriller",
                    "--main", "README.rdoc"]
  s.require_paths = ["lib"]
  #s.rubyforge_project = %q{cohortdriller}
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{Drill down cohort patients}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
