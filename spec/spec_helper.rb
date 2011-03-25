$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'tempfile'

require 'rspec'
require 'scaffolder/annotation_locator'

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

RSpec.configure do |config|

  def write_sequence_file(entries,file = Tempfile.new("sequence").path)
    File.open(file,'w') do |tmp|
      make_sequence(entries).each do |entry|
        seq = Bio::Sequence.new(entry[:sequence])
        tmp.print(seq.output(:fasta,:header => entry[:name]))
      end
    end
    file
  end

  def write_scaffold_file(entries,file = Tempfile.new("scaffold").path)
    File.open(file,'w'){|tmp| tmp.print(YAML.dump(make_scaffold(entries)))}
    file
  end

  def make_scaffold(entries)
    entries.map do |entry|
      {'sequence' => {'source' => (entry['name'] || entry[:name]) }}
    end
  end

  def make_sequence(entries)
    entries.map do |entry|
      {:name => (entry['name'] || entry[:name]),
        :sequence => (entry['nucleotides'] || entry[:nucleotides]) }
    end.flatten
  end

end
