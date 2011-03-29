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

RSpec::Matchers.define :set_the_annotation_attribute do |attribute|

  oridinals = [:first,:second,:third,:fourth,:fifth]

  match do |annotations|
    annotations[oridinals.index(@position)].send(attribute) == @expected
  end
  chain :to do |expected|
    @expected = expected
  end
  chain :for_the do |position|
    @position = position
  end
  description do
    "set the #{@position} annotation #{attribute} attribute to \"#{@expected}\""
  end
end
