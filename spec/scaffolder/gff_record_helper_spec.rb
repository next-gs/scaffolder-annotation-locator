require File.expand_path(File.join(File.dirname(__FILE__), '..', 'spec_helper'))

describe Scaffolder::GffRecordHelper do

  it "should be included in Bio::GFF::GFF3::Record" do
    Bio::GFF::GFF3::Record.ancestors.should include(described_class)
  end

  subject do
    Bio::GFF::GFF3::Record.new(nil,nil,'CDS',1,3,nil,'+')
  end

  describe "#flip_strand" do

    it "should change strand to '-' when flipped from '+'" do
      subject.flip_strand
      subject.strand.should == '-'
    end

    it "should change strand to '+' when flipped from '-'" do
      subject.strand = '-'
      subject.flip_strand
      subject.strand.should == '+'
    end

  end

  describe "#change_position_by" do

    before do
      subject.change_position_by 3
    end

    it "should increase start position" do
      subject.start.should == 4
    end

    it "should increase end position" do
      subject.end.should == 6
    end

  end

end
