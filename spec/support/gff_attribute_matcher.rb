ORDINALS = [:first,:second,:third,:fourth,:fifth]

RSpec::Matchers.define :set_the_attribute do |expected|
  match do |annotations|
    @attribute = expected.keys.first
    @value     = expected.values.first
    if @ordinal
      annotations[ORDINALS.index(@ordinal)].send(@attribute) == @value
    else
      annotations.all?{|a| a.send(@attribute) == @value }
    end
  end
  chain :only_for_the do |ordinal|
    @ordinal = ordinal
  end
  description do
    string = "set the annotation #{@attribute} attribute to \"#{@value}\""
    string << " for the #{@ordinal} annotation" if @ordinal
    string
  end
end
