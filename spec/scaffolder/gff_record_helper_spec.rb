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

  describe "#reverse_complement_by" do

    before do
      subject.reverse_complement_by 7
    end

    it "should increase start position" do
      subject.start.should == 5
    end

    it "should increase end position" do
      subject.end.should == 7
    end

    it "should flip the stand" do
      subject.strand.should == '-'
    end

  end

  describe "#overlap?" do

    it "should return false when no overlap with a single insert" do
      subject.overlap?(4..6).should be_false
    end

    it "should return true when overlapping with a single insert" do
      subject.overlap?(0..1).should be_true
      subject.overlap?(3..4).should be_true
      subject.overlap?(2..4).should be_true
    end

    it "should return false when no overlap with a multiple inserts" do
      subject.overlap?([4..6,7..9]).should be_false
    end

    it "should return true when overlapping with one of two inserts" do
      subject.overlap?([0..1,4..6]).should be_true
    end

  end

end
