require 'delegate'
require 'scaffolder'
require 'bio'

class Scaffolder::AnnotationLocator < DelegateClass(Array)

  def initialize(scaffold_file,sequence_file,gff_file)
    @scaffold_file = scaffold_file
    @sequence_file = sequence_file

    super(Bio::GFF::GFF3.new(File.read(gff_file)).records.map! do |record|

      sequence = sequences[record.seqname]
      if sequence.start > 1
        record.start -= sequence.start - 1
        record.end   -= sequence.start - 1
      end

      record.seqname = "scaffold"
      record
    end)
  end

  def sequences
    scaffold = Scaffolder.new(YAML.load(File.read(@scaffold_file)),@sequence_file)
    scaffold.inject(Hash.new) do |hash,entry|
      hash[entry.source] = entry if entry.entry_type == :sequence
      hash
    end
  end

end
