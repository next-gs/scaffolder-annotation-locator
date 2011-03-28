require 'delegate'
require 'scaffolder'
require 'bio'

class Scaffolder::AnnotationLocator < DelegateClass(Array)

  def initialize(scaffold_file,sequence_file,gff_file)
    @scaffold_file = scaffold_file
    @sequence_file = sequence_file

    running_length = 0
    super(Bio::GFF::GFF3.new(File.read(gff_file)).records.map! do |record|

      scaffold_entry = sequences[record.seqname]
      if scaffold_entry.start > 1
        record.start -= scaffold_entry.start - 1
        record.end   -= scaffold_entry.start - 1
      end

      record.start += running_length
      record.end   += running_length

      running_length += scaffold_entry.sequence.length

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
