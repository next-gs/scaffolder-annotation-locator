RSpec::Matchers.define :set_all_annotation_attributes_for do |attribute|
  match do |annotations|
    annotations.all?{|a| a.send(attribute) == @expected }
  end
  chain :to do |expected|
    @expected = expected
  end
  description do
    "set each annotation #{attribute} attribute to \"#{@expected}\""
  end
end
