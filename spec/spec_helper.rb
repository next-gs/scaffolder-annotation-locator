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
      hash = {'source' => (entry['name'] || entry[:name]) }
      hash['start'] = entry[:start] if entry[:start]
      { 'sequence' => hash }
    end
  end

  def make_sequence(entries)
    entries.map do |entry|
      {:name => (entry['name'] || entry[:name]),
        :sequence => (entry['nucleotides'] || entry[:nucleotides]) }
    end.flatten
  end

  def generate_gff3_file(annotations)
    gff = Bio::GFF::GFF3.new
    gff.records = annotations.map do |a|
      Bio::GFF::GFF3::Record.new(a[:seqname], a[:source], 'CDS', a[:start],
       a[:end], nil, a[:strand],  a[:phase])
    end

    tmp = Tempfile.new("gff").path
    File.open(tmp,'w'){ |out| out.print(gff) }
    tmp
  end

end
