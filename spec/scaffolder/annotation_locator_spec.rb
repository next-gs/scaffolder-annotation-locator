require File.expand_path(File.join(File.dirname(__FILE__), '..', 'spec_helper'))

describe Scaffolder::AnnotationLocator do

  describe "relocating a an empty gff file" do

    before(:all) do
      entries = [{:name => 'contig1', :nucleotides => 'ATGC'}]

      @gff3_file = generate_gff3_file([])
      @scaffold_file = write_scaffold_file(entries)
      @sequence_file = write_sequence_file(entries)

      @annotations = described_class.new(@scaffold_file, @sequence_file, @gff3_file)
    end

    subject do
      @annotations
    end

    it "should return an empty annotation array" do
      subject.should be_empty
    end

  end

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
      @annotations
    end

    it{ should set_the_attribute(:seqname => 'scaffold') }
    it{ should set_the_attribute(:phase   => 1) }
    it{ should set_the_attribute(:strand  => '+') }

    it{ should set_the_attribute(:start   => 4).only_for_the(:first) }
    it{ should set_the_attribute(:end     => 6).only_for_the(:first) }

  end

  describe "relocating a single annotation on a single reversed contig" do

    before(:all) do
      entries = [{:name => 'contig1', :nucleotides => 'ATGCCC', :reverse => true}]

      @record = { :seqname => 'contig1',
        :start => 4, :end => 6, :strand => '+',:phase => 1}
      @gff3_file = generate_gff3_file([@record])
      @scaffold_file = write_scaffold_file(entries)
      @sequence_file = write_sequence_file(entries)

      @annotations = described_class.new(@scaffold_file, @sequence_file, @gff3_file)
    end

    subject do
      @annotations
    end

    it{ should set_the_attribute(:seqname => 'scaffold') }
    it{ should set_the_attribute(:phase   => 1) }
    it{ should set_the_attribute(:strand  => '-') }

    it{ should set_the_attribute(:start   => 1).only_for_the(:first) }
    it{ should set_the_attribute(:end     => 3).only_for_the(:first) }

  end

  describe "relocating a reverse strand annotation on a single reversed contig" do

    before(:all) do
      entries = [{:name => 'contig1', :nucleotides => 'ATGCCC', :reverse => true}]

      @record = { :seqname => 'contig1',
        :start => 4, :end => 6, :strand => '-',:phase => 1}
      @gff3_file = generate_gff3_file([@record])
      @scaffold_file = write_scaffold_file(entries)
      @sequence_file = write_sequence_file(entries)

      @annotations = described_class.new(@scaffold_file, @sequence_file, @gff3_file)
    end

    subject do
      @annotations
    end

    it{ should set_the_attribute(:seqname => 'scaffold') }
    it{ should set_the_attribute(:phase   => 1) }
    it{ should set_the_attribute(:strand  => '+') }

    it{ should set_the_attribute(:start   => 1).only_for_the(:first) }
    it{ should set_the_attribute(:end     => 3).only_for_the(:first) }

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
      @annotations
    end

    it{ should set_the_attribute(:seqname => 'scaffold') }
    it{ should set_the_attribute(:phase   => 1) }
    it{ should set_the_attribute(:strand  => '+') }

    it{ should set_the_attribute(:start   => 1).only_for_the(:first) }
    it{ should set_the_attribute(:end     => 3).only_for_the(:first) }

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

    it{ should set_the_attribute(:seqname => 'scaffold') }
    it{ should set_the_attribute(:phase   => 1) }
    it{ should set_the_attribute(:strand  => '+') }

    it{ should set_the_attribute(:start   => 4).only_for_the(:first) }
    it{ should set_the_attribute(:end     => 6).only_for_the(:first) }

    # First contig length: 6
    it{ should set_the_attribute(:start   => 10).only_for_the(:second) }
    it{ should set_the_attribute(:end     => 12).only_for_the(:second) }

  end

  describe "relocating two unordered annotations on two contigs" do

    before(:all) do
      @sequences = [{:name => 'c1', :nucleotides => 'AAATTT'},
                    {:name => 'c2', :nucleotides => 'AAATTT'}]

      one = {:seqname => 'c1', :start => 1, :end => 3, :strand => '-',:phase => 1}
      two = {:seqname => 'c2', :start => 4, :end => 6, :strand => '+',:phase => 1}
      @entries = [two,one]

      @gff3_file = generate_gff3_file(@entries)
      @scaffold_file = write_scaffold_file(@sequences)
      @sequence_file = write_sequence_file(@sequences)
      @annotations = described_class.new(@scaffold_file, @sequence_file, @gff3_file)
    end

    subject do
      @annotations
    end

    it{ should set_the_attribute(:seqname => 'scaffold') }
    it{ should set_the_attribute(:phase   => 1) }

    it{ should set_the_attribute(:start   => 1).only_for_the(:first) }
    it{ should set_the_attribute(:end     => 3).only_for_the(:first) }
    it{ should set_the_attribute(:strand  => '-').only_for_the(:first) }

    # First contig length: 6
    it{ should set_the_attribute(:start   => 10).only_for_the(:second) }
    it{ should set_the_attribute(:end     => 12).only_for_the(:second) }
    it{ should set_the_attribute(:strand  => '+').only_for_the(:second) }

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

    it{ should set_the_attribute(:seqname => 'scaffold') }
    it{ should set_the_attribute(:phase   => 1) }
    it{ should set_the_attribute(:strand  => '+') }

    it{ should set_the_attribute(:start   => 1).only_for_the(:first) }
    it{ should set_the_attribute(:end     => 3).only_for_the(:first) }

    # First contig length: 6
    it{ should set_the_attribute(:start   => 7).only_for_the(:second) }
    it{ should set_the_attribute(:end     => 9).only_for_the(:second) }

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

    it{ should set_the_attribute(:seqname => 'scaffold') }
    it{ should set_the_attribute(:phase   => 1) }
    it{ should set_the_attribute(:strand  => '+') }

    it{ should set_the_attribute(:start   => 4).only_for_the(:first) }
    it{ should set_the_attribute(:end     => 6).only_for_the(:first) }

    # First contig length: 6
    it{ should set_the_attribute(:start   => 7).only_for_the(:second) }
    it{ should set_the_attribute(:end     => 9).only_for_the(:second) }

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

    its(:length){ should == 2 }
    it{ should set_the_attribute(:seqname => 'scaffold') }
    it{ should set_the_attribute(:phase   => 1) }
    it{ should set_the_attribute(:strand  => '+') }

    it{ should set_the_attribute(:start   => 1).only_for_the(:first) }
    it{ should set_the_attribute(:end     => 3).only_for_the(:first) }

    # First contig length: 6
    it{ should set_the_attribute(:start   => 7).only_for_the(:second) }
    it{ should set_the_attribute(:end     => 9).only_for_the(:second) }

  end

  describe "relocating two annotations on two contigs with an unresolved region" do

    before(:all) do
      @sequences = [{:name       => 'c1', :nucleotides => 'AAATTT'},
                    {:unresolved => 10},
                    {:name       => 'c2', :nucleotides => 'AAATTT'}]

      one = {:seqname => 'c1', :start => 4, :end => 6, :strand => '+',:phase => 1}
      two = {:seqname => 'c2', :start => 1, :end => 3, :strand => '+',:phase => 1}
      @entries = [one,two]

      @gff3_file = generate_gff3_file(@entries)
      @scaffold_file = write_scaffold_file(@sequences)
      @sequence_file = write_sequence_file(@sequences)
      @annotations = described_class.new(@scaffold_file, @sequence_file, @gff3_file)

    end

    subject do
      @annotations
    end

    it{ should set_the_attribute(:seqname => 'scaffold') }
    it{ should set_the_attribute(:phase   => 1) }
    it{ should set_the_attribute(:strand  => '+') }

    it{ should set_the_attribute(:start   => 4).only_for_the(:first) }
    it{ should set_the_attribute(:end     => 6).only_for_the(:first) }

    # First contig length: 6
    # Unresolved region length: 10
    it{ should set_the_attribute(:start   => 17).only_for_the(:second) }
    it{ should set_the_attribute(:end     => 19).only_for_the(:second) }

  end

  describe "records method" do

    before(:all) do
      @sequences = [{:name       => 'c1', :nucleotides => 'AAATTT'},
                    {:name       => 'c2', :nucleotides => 'AAATTT'}]

      one = {:seqname => 'c1', :start => 4, :end => 6, :strand => '+',:phase => 1}
      two = {:seqname => 'c2', :start => 1, :end => 3, :strand => '+',:phase => 1}
      @entries = [one,two]

      @gff3_file = generate_gff3_file(@entries)
      @scaffold_file = write_scaffold_file(@sequences)
      @sequence_file = write_sequence_file(@sequences)
    end

    subject do
      described_class.new(@scaffold_file,@sequence_file,@gff3_file).records
    end

    it "should return the gff records grouped by sequence" do
      subject['c1'].length.should == 1
      subject['c2'].length.should == 1
    end

  end

  describe "the flip strand method" do

    it "should return '+' when passed '-'" do
      described_class.flip_strand('+').should == '-'
    end

    it "should return '-' when passed '+'" do
      described_class.flip_strand('-').should == '+'
    end

  end
end
