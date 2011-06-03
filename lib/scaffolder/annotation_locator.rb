require 'delegate'
require 'scaffolder'
require 'bio'

require 'scaffolder/extensions'

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

    scaffold_entry.inserts.select {|i| i.close < record.start }.each do |insert|
      location_size = (insert.close - insert.open) + 1
      insert_size = insert.sequence.length

      diff =  insert_size - location_size
      record.change_position_by diff
    end

    # Decrease record position by distance contig is trimmed at start
    record.change_position_by(1 - scaffold_entry.start)

    # Reverse complement record positions if contig is reversed
    if scaffold_entry.reverse
       record.reverse_complement_by scaffold_entry.sequence.length
    end

    # Increase record position by length of prior contigs
    record.change_position_by prior_length

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

end
