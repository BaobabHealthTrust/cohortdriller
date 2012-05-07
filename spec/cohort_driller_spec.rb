
require File.expand_path(File.dirname(__FILE__) + '/spec_helper')


describe EncounterExporter do

  before(:each) do
    out_dir = '/tmp'
    @exporter = EncounterExporter.new(out_dir, 1)
    obs_headers = ['Patient present', 'Guardian present']
    @exporter.stub!(:headers => @exporter.default_fields + obs_headers)

    @encounter = mock('Encounter')
    @encounter.stub!(
      :patient_id         => 1,
      :encounter_id       => 1,
      :encounter_datetime => Time.now,
      :location_id        => 1,
      :date_created       => Time.now,
      :provider_id        => 1
    )

    @datetime = Time.now
    @row_values = [1,1,1, @datetime, @datetime, 1, # encounter
                   0, 1, nil, nil,                 # void data
                   '3', '3'
    ]

    @exporter.stub!(:to_csv) do |filename|
      FasterCSV.open(out_dir + '/' + filename, 'w', :headers => true) do |csv|
        csv << @exporter.headers
        csv << @row_values
      end
    end

  end

  it "should get file name" do
    @exporter.to_filename('HIV Reception').should == 'hiv_reception'
  end

  it "should get field headers" do
    @exporter.default_fields.should_not be_nil
    @exporter.headers.should_not be_nil
  end

  it "should get encounter row" do
    @exporter.stub(:row => @row_values)                       # obs answers
    @exporter.row(@encounter).length.should == @exporter.headers.length
  end

  it "should create the CSV file" do
    file = 'hiv_reception.csv'
    @exporter.to_csv(file)
    File.exist?(@exporter.csv_dir + file).should be_true
  end

  it "should get observation's value" do
    o = mock('Observation')
    o.stub!(:concept_id    => 1,
            :value_coded   => 3,
            :value_numeric => 7.0,
            :attributes    => {
              'concept_id'    => 1,
              'value_coded'   => 3,
              'value_numeric' => 7.0
            }
    )
    
    @exporter.obs_value(o).should == '3;7.0'
    o.stub!(:value_coded => nil, :value_numeric => 7.0,
             :attributes    => {
              'concept_id'    => 1,
              'value_coded'   => nil,
              'value_numeric' => 7.0
            }
    )
    @exporter.obs_value(o).should == '7.0'
  end
  
end