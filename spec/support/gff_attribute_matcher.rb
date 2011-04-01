ORDINALS = [:first,:second,:third,:fourth,:fifth]

RSpec::Matchers.define :set_the_attribute do |expected|
  match do |annotations|
    @attribute = expected.keys.first
    @value     = expected.values.first
    if @ordinal
      @actual = annotations[ORDINALS.index(@ordinal)].send(@attribute)
       @actual == @value
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

  failure_message_for_should do |annotations|
    message = "expected \"#{@attribute}\" to be \"#{@value}\" "
    message + if @ordinal
      "but was \"#{actual}\" for the #{@ordinal} annotation"
    else
      "for all annotations"
    end
  end

end
