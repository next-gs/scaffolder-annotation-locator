module Scaffolder::GffRecordHelper

  def flip_strand
    self.strand = (self.strand == '+' ? '-' : '+')
  end

  def change_position_by(distance)
    self.start += distance
    self.end += distance
  end

end
