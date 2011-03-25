When /^I relocate the annotations using "([^"]*)", "([^"]*)" and "([^"]*)"$/ do |scaffold, sequence, annotations|
  gff3 = Bio::GFF::GFF3.new

  gff3.records = Scaffolder::AnnotationLocator.new(
    'tmp/aruba/' + scaffold,
    'tmp/aruba/' + sequence,
    'tmp/aruba/' + annotations)
  @result = gff3.to_s.strip
end

Then /^the result should be:$/ do |result|
  @result.should == result
end
