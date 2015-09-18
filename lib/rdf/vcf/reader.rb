require 'java' # requires JRuby
require 'rdf/vcf/jar/htsjdk-1.139.jar'
require 'rdf/vcf/jar/bzip2.jar'

require 'rdf/vcf/record'

module RDF; module VCF
  ##
  # VCF file reader.
  #
  # This is a user-friendly wrapper for the HTSJDK implementation.
  #
  # @see https://github.com/samtools/htsjdk
  # @see https://samtools.github.io/htsjdk/javadoc/htsjdk/htsjdk/variant/vcf/VCFFileReader.html
  class Reader
    java_import 'htsjdk.variant.vcf.VCFFileReader'

    REF_BASE_URI = 'http://rdf.ebi.ac.uk/resource/ensembl/%s/chromosome:%s:%s'.freeze

    def ref_base_uri #
      @file_iri ||= RDF::URI(REF_BASE_URI % ["test", file_date, source])
    end


    ##
    # @param [#to_s] pathname
    def self.open(pathname, &block)
      reader = self.new(pathname)
      block.call(reader)
    ensure
      #reader.close
    end

    ##
    # @param [#to_s] pathname
    def initialize(pathname)
      pathname = pathname.to_s
      @vcf_file = java.io.File.new(pathname)
      @tbi_file = java.io.File.new("#{pathname}.tbi")
      @reader = VCFFileReader.new(@vcf_file, @tbi_file, true)
    end

    ##
    # @return [Boolean]
    def closed?
      @reader.nil?
    end

    ##
    # @return [void]
    def close
      @reader.close if @reader
    ensure
      @reader, @vcf_file, @tbi_file = nil, nil, nil
    end

    ##
    # @yield  [statement]
    # @yieldparam  [RDF::Statement] statement
    # @yieldreturn [void]
    # @return [void]
    def each_statement(&block)
      self.each_record do |record|
        record.to_rdf.each(&block)
      end
    end

    ##
    # @yield  [record]
    # @yieldparam  [Record] record
    # @yieldreturn [void]
    # @return [void]
    def each_record(&block)
      return unless @reader
      @reader.iterator.each do |variant_context| # VariantContext
        record = Record.new(variant_context, self)
        block.call(record)
      end
    end

    ##
    # @param  [String]  chromosome
    # @param  [Integer] start_pos
    # @param  [Integer] end_pos
    # @yield  [record]
    # @yieldparam  [Record] record
    # @yieldreturn [void]
    # @return [void]
    def find_records(chromosome: nil, start_pos: nil, end_pos: nil, &block)
      return unless @reader
      start_pos  ||= 0
      end_pos    ||= java.lang.Integer::MAX_VALUE
      @reader.query(chromosome, start_pos, end_pos).each do |variant_context| # VariantContext
        record = Record.new(variant_context, @reader)
        block.call(record)
      end
    end

    ##
    # @param  [Integer] pos
    # @return [Boolean]
    def has_position?(pos)
      true # TODO
    end

    ##
    # @return [String]
    def reference
      @reference ||= @reader.getFileHeader().getMetaDataLine("reference").getKey
    end

    ##
    # @return [String]
    def file_date
      @file_date ||= @reader.getFileHeader().getMetaDataLine("fileDate").getKey
    end

    ##
    # @return [String]
    def source
      @source ||= @reader.getFileHeader().getMetaDataLine("source").getKey
    end



  end # Reader
end; end # RDF::VCF

if $0 == __FILE__
  VCF::Reader.open('Homo_sapiens.vcf.gz') do |file|
    p file
    file.find_records(chromosome: "Y") do |record|
    #file.each_record do |record|
      p record
      #record.to_rdf.each do |statement|
      #  p statement
      #end
    end
  end
end
