require 'delegate'
require 'scaffolder'
require 'bio'

class Scaffolder::AnnotationLocator < DelegateClass(Array)

  def initialize(scaffold_file,sequence_file,gff_file)
    super(Bio::GFF::GFF3.new(File.read(gff_file)).records.map! do |record|
      record.seqname = "scaffold"
      record
    end)
  end

end
