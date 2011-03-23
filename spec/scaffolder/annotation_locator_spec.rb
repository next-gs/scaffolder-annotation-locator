require File.expand_path(File.join(File.dirname(__FILE__), '..', 'spec_helper'))

describe Scaffolder::AnnotationLocator do


  def generate_gff3_file(annotations)
    tmp = Tempfile.new(Time.new).path
    File.open(tmp,'w') do |out|
      out.puts "#gff-version 3"
      out.print(annotations.map do |a|
        [a[:source],'.','CDS',a[:start],a[:stop],'.',a[:phase],"ID=#{a[:id]}"]*'\t'
      end * '\n')
    end
    tmp
  end

  describe "relocating a single annotation on a single contig" do

    before do
      entries = [{:name => 'seq1', :nucleotides => 'ATGC'}]

      @scaffold_file = Tempfile.new("scaffold").path
      @sequence_file = Tempfile.new("sequence").path

      write_scaffold_file(entries,@scaffold_file)
      write_sequence_file(entries,@sequence_file)
    end

    it "should be initializable with scaffold and gff3 file" do
      expect {
        described_class.new(@scaffold_file, @sequence_file, @gff3_file)
      }.to_not raise_error
    end

  end


end
