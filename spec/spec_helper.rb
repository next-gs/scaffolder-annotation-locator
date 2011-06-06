$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'tempfile'

require 'rspec'
require 'scaffolder/test/helpers'
require 'scaffolder/annotation_locator'

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

RSpec.configure do |config|
  include Scaffolder::Test
  include Scaffolder::Test::Helpers

  def generate_gff3_file(annotations)
    gff = Bio::GFF::GFF3.new
    gff.records = annotations.map do |a|
      Bio::GFF::GFF3::Record.new(a[:seqname], a[:source], 'CDS', a[:start],
       a[:end], nil, a[:strand],  a[:phase])
    end

    tmp = Tempfile.new("gff")
    File.open(tmp.path,'w'){ |out| out.print(gff) }
    tmp
  end

end
