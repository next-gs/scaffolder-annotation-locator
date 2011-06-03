module Scaffolder::GffRecordHelper

  def flip_strand
    self.strand = (self.strand == '+' ? '-' : '+')
  end

end
