require 'scaffolder/gff_record_helper'

Bio::GFF::GFF3::Record.send(:include, Scaffolder::GffRecordHelper)
