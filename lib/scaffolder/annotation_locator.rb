require 'delegate'
require 'scaffolder'
require 'bio'
require 'psych'

require 'scaffolder/extensions'

class Scaffolder::AnnotationLocator < DelegateClass(Array)

  def initialize(scaffold_file,sequence_file,gff_file)
    @scaffold_file = scaffold_file
    @sequence_file = sequence_file
    @gff_file      = gff_file

    updated_records = Array.new
    scaffold.inject(0) do |prior_length,entry|

      if entry.entry_type == :sequence
        records[entry.source].each do |record|

          # Don't include this record if it overlaps with an insert
          next if record.overlap?(entry.inserts.map{|i| (i.open..i.close)})

          # Skip this record it lies in the start or stop trimmed regions
          next if record.start < entry.start
          next if record.end   > entry.stop

          # Update record location by size differences of prior inserts
          entry.inserts.select {|i| i.close < record.start }.each do |insert|
            record.change_position_by insert.size_diff
          end

          # Decrease record position by distance contig is trimmed at start
          record.change_position_by(1 - entry.start)

          # Reverse complement record positions if contig is reversed
          record.reverse_complement_by entry.sequence.length if entry.reverse

          # Increase record position by length of prior contigs
          record.change_position_by prior_length

          record.seqname = "scaffold"

          updated_records << record
        end
      end

      prior_length + entry.sequence.length
    end

    super updated_records
  end

  def scaffold
    Scaffolder.new(Psych.load(File.read(@scaffold_file)),@sequence_file)
  end

  def records
    gff3 = Bio::GFF::GFF3.new(File.read(@gff_file)).records
    gff3.inject(Hash.new{|h,k| h[k] = Array.new }) do |hash,record|
      hash[record.seqname] << record
      hash
    end
  end

end
