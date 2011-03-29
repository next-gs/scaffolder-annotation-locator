require File.expand_path(File.join(File.dirname(__FILE__), '..', 'spec_helper'))

describe Scaffolder::AnnotationLocator do

  describe "relocating a single annotation on a single contig" do

    before(:all) do
      entries = [{:name => 'contig1', :nucleotides => 'ATGC'}]

      @record = { :seqname => 'contig1',
        :start => 4, :end => 6, :strand => '+',:phase => 1}
      @gff3_file = generate_gff3_file([@record])
      @scaffold_file = write_scaffold_file(entries)
      @sequence_file = write_sequence_file(entries)

      @annotations = described_class.new(@scaffold_file, @sequence_file, @gff3_file)
    end

    subject do
      @annotations.first
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

  describe "relocating a single annotation on a trimmed contig" do

    before(:all) do
      entries = [{:name => 'contig1', :nucleotides => 'ATGC', :start => 4}]

      @record = { :seqname => 'contig1',
        :start => 4, :end => 6, :strand => '+',:phase => 1}
      @gff3_file = generate_gff3_file([@record])
      @scaffold_file = write_scaffold_file(entries)
      @sequence_file = write_sequence_file(entries)

      @annotations = described_class.new(@scaffold_file, @sequence_file, @gff3_file)
    end

    subject do
      @annotations.first
    end

    it "should have scaffold as sequence name" do
      subject.seqname.should == "scaffold"
    end

    it "should have same start position" do
      subject.start.should == 1
    end

    it "should have same end position" do
      subject.end.should == 3
    end

    it "should have same strand" do
      subject.strand.should == @record[:strand]
    end

    it "should have same phase" do
      subject.phase.should == @record[:phase]
    end

  end

  describe "relocating two annotations on two contigs" do

    before(:all) do
      @sequences = [{:name => 'c1', :nucleotides => 'AAATTT'},
                    {:name => 'c2', :nucleotides => 'AAATTT'}]

      one = {:seqname => 'c1', :start => 4, :end => 6, :strand => '+',:phase => 1}
      two = {:seqname => 'c2', :start => 4, :end => 6, :strand => '+',:phase => 1}
      @entries = [one,two]

      @gff3_file = generate_gff3_file(@entries)
      @scaffold_file = write_scaffold_file(@sequences)
      @sequence_file = write_sequence_file(@sequences)
      @annotations = described_class.new(@scaffold_file, @sequence_file, @gff3_file)
    end

    subject do
      @annotations
    end

    it{ should name_each_annotation 'scaffold' }

    it "each entry should have the expected phase" do
      subject.each_with_index do |annotation,i|
        annotation.phase.should == @entries[i][:phase]
      end
    end

    it "each entry should have the expected strand" do
      subject.each_with_index do |annotation,i|
        annotation.strand.should == @entries[i][:strand]
      end
    end

    it "should have the same cooridinates for the first entry" do
      subject.first.start.should == @entries.first[:start]
      subject.first.end.should == @entries.first[:end]
    end

    it "should update second contig cooridinates by first contig length" do
      difference = @sequences.first[:nucleotides].length
      subject.last.start.should == @entries.last[:start] + difference
      subject.last.end.should   == @entries.last[:end]   + difference
    end

  end

  describe "relocating where the first of two contigs is start trimmed" do

    before(:all) do
      @sequences = [{:name => 'c1', :nucleotides => 'AAATTT', :start => 4},
                    {:name => 'c2', :nucleotides => 'AAATTT'}]

      one = {:seqname => 'c1', :start => 4, :end => 6, :strand => '+',:phase => 1}
      two = {:seqname => 'c2', :start => 4, :end => 6, :strand => '+',:phase => 1}
      @entries = [one,two]

      @gff3_file = generate_gff3_file(@entries)
      @scaffold_file = write_scaffold_file(@sequences)
      @sequence_file = write_sequence_file(@sequences)
      @annotations = described_class.new(@scaffold_file, @sequence_file, @gff3_file)
    end

    subject do
      @annotations
    end

    it{ should name_each_annotation 'scaffold' }

    it "each entry should have the expected phase" do
      subject.each_with_index do |annotation,i|
        annotation.phase.should == @entries[i][:phase]
      end
    end

    it "each entry should have the expected strand" do
      subject.each_with_index do |annotation,i|
        annotation.strand.should == @entries[i][:strand]
      end
    end

    it "should update the coordinates for the first entry" do
      difference = @sequences.first[:start] - 1
      subject.first.start.should == @entries.first[:start] - difference
      subject.first.end.should   == @entries.first[:end]   - difference
    end

    it "should update second contig cooridinates by first contig length" do
      difference = @sequences.first[:nucleotides].length -
                   (@sequences.first[:start] - 1)
      subject.last.start.should == @entries.last[:start] + difference
      subject.last.end.should   == @entries.last[:end]   + difference
    end

  end

  describe "relocating where the second of two contigs is start trimmed" do

    before(:all) do
      @sequences = [{:name => 'c1', :nucleotides => 'AAATTT'},
                    {:name => 'c2', :nucleotides => 'AAATTT', :start => 4}]

      one = {:seqname => 'c1', :start => 4, :end => 6, :strand => '+',:phase => 1}
      two = {:seqname => 'c2', :start => 4, :end => 6, :strand => '+',:phase => 1}
      @entries = [one,two]

      @gff3_file = generate_gff3_file(@entries)
      @scaffold_file = write_scaffold_file(@sequences)
      @sequence_file = write_sequence_file(@sequences)

      @annotations = described_class.new(@scaffold_file, @sequence_file, @gff3_file)
    end

    subject do
      @annotations
    end

    it{ should name_each_annotation 'scaffold' }

    it "each entry should have the expected phase" do
      subject.each_with_index do |annotation,i|
        annotation.phase.should == @entries[i][:phase]
      end
    end

    it "each entry should have the expected strand" do
      subject.each_with_index do |annotation,i|
        annotation.strand.should == @entries[i][:strand]
      end
    end

    it "should maintain the coordinates for the first entry" do
      subject.first.start.should == @entries.first[:start]
      subject.first.end.should   == @entries.first[:end]
    end

    it "should update second contig cooridinates by first contig length" do
      difference = @sequences.first[:nucleotides].length -
                   (@sequences.last[:start] - 1)
      subject.last.start.should == @entries.last[:start] + difference
      subject.last.end.should   == @entries.last[:end]   + difference
    end

  end

  describe "relocating where the first of two contigs is stop trimmed" do

    before(:all) do
      @sequences = [{:name => 'c1', :nucleotides => 'AAATTT', :stop => 3},
                    {:name => 'c2', :nucleotides => 'AAATTT'}]

      one = {:seqname => 'c1', :start => 1, :end => 3, :strand => '+',:phase => 1}
      two = {:seqname => 'c2', :start => 4, :end => 6, :strand => '+',:phase => 1}
      @entries = [one,two]

      @gff3_file = generate_gff3_file(@entries)
      @scaffold_file = write_scaffold_file(@sequences)
      @sequence_file = write_sequence_file(@sequences)

      @annotations = described_class.new(@scaffold_file, @sequence_file, @gff3_file)
    end

    subject do
      @annotations
    end

    it{ should name_each_annotation 'scaffold' }

    it "each entry should have the expected phase" do
      subject.each_with_index do |annotation,i|
        annotation.phase.should == @entries[i][:phase]
      end
    end

    it "each entry should have the expected strand" do
      subject.each_with_index do |annotation,i|
        annotation.strand.should == @entries[i][:strand]
      end
    end

    it "should return the expect annotation coordinates for the first contig" do
      subject.first.start.should == 1
      subject.first.end.should   == 3
    end

    it "should return the expect annotation coordinates for the second contig" do
      subject.last.start.should == 7
      subject.last.end.should   == 9
    end

  end

  describe "the sequences hash" do

    before(:all) do
      @name = 'something'
      entries = [{:name => @name, :nucleotides => 'ATGC'}]
      @gff3_file = generate_gff3_file([])
      @scaffold_file = write_scaffold_file(entries)
      @sequence_file = write_sequence_file(entries)
    end

    subject do
      described_class.new(@scaffold_file,@sequence_file,@gff3_file)
    end

    it "should contain the expected sequence as a hash key" do
      subject.sequences.keys.should == [@name]
    end

  end

end
