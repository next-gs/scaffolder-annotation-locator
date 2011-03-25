require File.expand_path(File.join(File.dirname(__FILE__), '..', 'spec_helper'))

describe Scaffolder::AnnotationLocator do


  def generate_gff3_file(annotations)
    tmp = Tempfile.new(Time.new).path
    File.open(tmp,'w') do |out|
      out.puts "##gff-version 3"
      out.print(annotations.map do |a|
        [a[:seqname],'.','CDS',a[:start],a[:end],'.',a[:strand],a[:phase]]*"\t"
      end * '\n')
    end
    tmp
  end

  describe "relocating a single annotation on a single contig" do

    before do
      entries = [{:name => 'seq1', :nucleotides => 'ATGC'}]

      @record = { :seqname => 'contig1',
        :start => 4, :end => 6, :strand => '+',:phase => 1}
      @gff3_file = generate_gff3_file([@record])
      @scaffold_file = Tempfile.new("scaffold").path
      @sequence_file = Tempfile.new("sequence").path

      write_scaffold_file(entries,@scaffold_file)
      write_sequence_file(entries,@sequence_file)
    end

    subject do
      described_class.new(@scaffold_file, @sequence_file, @gff3_file).first
    end

    it "should have scaffold as sequence name" do
      subject.seqname.should == "scaffold"
    end

    it "should have same start position" do
      subject.start.should == @record[:start]
    end

    it "should have same end position" do
      subject.end.should == @record[:end]
    end

    it "should have same strand" do
      subject.strand.should == @record[:strand]
    end

    it "should have same phase" do
      subject.phase.should == @record[:phase]
    end

  end

end
