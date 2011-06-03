require File.expand_path(File.join(File.dirname(__FILE__), '..', 'spec_helper'))

describe Scaffolder::GffRecordHelper do

  it "should be included in Bio::GFF::GFF3::Record" do
    Bio::GFF::GFF3::Record.ancestors.should include(described_class)
  end

  describe "#flip_strand" do

    it "should change strand to '-' when flipped from '+'" do
      record = Bio::GFF::GFF3::Record.new(nil,nil,'CDS',1,3,nil,'+')
      record.flip_strand
      record.strand.should == '-'
    end

    it "should change strand to '+' when flipped from '-'" do
      record = Bio::GFF::GFF3::Record.new(nil,nil,'CDS',1,3,nil,'-')
      record.flip_strand
      record.strand.should == '+'
    end

  end

end
