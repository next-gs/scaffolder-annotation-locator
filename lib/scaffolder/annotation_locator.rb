require 'delegate'
require 'scaffolder'
require 'bio'

class Scaffolder::AnnotationLocator < DelegateClass(Array)

  def initialize(scaffold_file,sequence_file,gff_file)
    @scaffold_file = scaffold_file
    @sequence_file = sequence_file

    gff3 = Bio::GFF::GFF3.new(File.read(gff_file)).records
    records_by_sequence = gff3.inject(Hash.new(Array.new)) do |hash,record|
      hash[record.seqname] << record
      hash
    end

    updated_records = Array.new
    scaffold.inject(0) do |running_length,entry|

      if entry.entry_type == :sequence
        records_by_sequence[entry.source].each do |record|
          updated_records << update_record(record,entry,running_length)
        end
      end

      running_length + entry.sequence.length
    end

    super updated_records
  end

  def update_record(record,scaffold_entry,prior_length)
    if scaffold_entry.start > 1
      record.start -= scaffold_entry.start - 1
      record.end   -= scaffold_entry.start - 1
    end

    if scaffold_entry.reverse
      record.end   = scaffold_entry.sequence.length - (record.end - 1)
      record.start = scaffold_entry.sequence.length - (record.start - 1)

      record.end, record.start = record.start, record.end
      record.strand = self.class.flip_strand(record.strand)
    end

    record.start += prior_length
    record.end   += prior_length

    record.seqname = "scaffold"
    record
  end

  def scaffold
    Scaffolder.new(YAML.load(File.read(@scaffold_file)),@sequence_file)
  end

  def sequences
    scaffold.inject(Hash.new) do |hash,entry|
      hash[entry.source] = entry if entry.entry_type == :sequence
      hash
    end
  end

  def self.flip_strand(strand)
    strand == '+' ? '-' : '+'
  end

end
