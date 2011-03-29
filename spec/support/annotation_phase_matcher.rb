RSpec::Matchers.define :set_the_phase_for_each_annotation_to do |phase|
  match do |annotations|
    annotations.all?{|a| a.phase == phase }
  end
  description do
    "give each annotation the phase \"#{phase}\""
  end
end
