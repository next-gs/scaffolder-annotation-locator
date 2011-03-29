RSpec::Matchers.define :name_each_annotation do |name|
  match do |annotations|
    annotations.all?{|a| a.seqname == name }
  end
  description do
    "give each annotation the seqname \"#{name}\""
  end
end
