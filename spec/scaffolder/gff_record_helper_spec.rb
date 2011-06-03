require File.expand_path(File.join(File.dirname(__FILE__), '..', 'spec_helper'))

describe Scaffolder::GffRecordHelper do

  it "should be included in Bio::GFF::GFF3::Record" do
    Bio::GFF::GFF3::Record.ancestors.should include(described_class)
  end

end
