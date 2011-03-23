require 'delegate'
require 'scaffolder'
require 'bio'

class Scaffolder::AnnotationLocator < DelegateClass(Array)

  def initialize(scaffold_file,sequence_file,gff_file)
    Bio::GFF::GFF3.parse(File.read(gff_file))
  end

end
