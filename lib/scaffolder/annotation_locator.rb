require 'delegate'
require 'scaffolder'
require 'bio'

class Scaffolder::AnnotationLocator < DelegateClass(Array)

  def initialize(scaffold_file,sequence_file,gff_file)
    @scaffold_file = scaffold_file
    @sequence_file = sequence_file
    @gff_file      = gff_file

    updated_records = Array.new
    scaffold.inject(0) do |length,entry|

      if entry.entry_type == :sequence
        updated_records << records[entry.source].map do |record|
          update_record(record,entry,length)
        end
      end

      length + entry.sequence.length
    end

    super updated_records.flatten
  end

  def update_record(record,scaffold_entry,prior_length)
    record.start -= scaffold_entry.start - 1
    record.end   -= scaffold_entry.start - 1

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

  def records
    gff3 = Bio::GFF::GFF3.new(File.read(@gff_file)).records
    gff3.inject(Hash.new{|h,k| h[k] = Array.new }) do |hash,record|
      hash[record.seqname] << record
      hash
    end
  end

  def self.flip_strand(strand)
    strand == '+' ? '-' : '+'
  end

end
