module Scaffolder::GffRecordHelper

  def flip_strand
    self.strand = (self.strand == '+' ? '-' : '+')
  end

  def change_position_by(distance)
    self.start += distance
    self.end += distance
  end

  def reverse_complement_by(distance)
    self.end   = distance - (self.end - 1)
    self.start = distance - (self.start - 1)

    self.end, self.start = self.start, self.end
    self.flip_strand
  end

  def overlap?(*ranges)
    ranges.flatten.any? do |range|
      range.include?(self.start) || range.include?(self.end)
    end
  end

end
