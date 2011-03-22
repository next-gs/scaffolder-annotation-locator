When /^I relocate the annotations using "([^"]*)", "([^"]*)" and "([^"]*)"$/ do |scaffold, sequence, annotations|
  puts Scaffolder::AnnotationLocator.new(scaffold,sequence,annotations).locate
end
