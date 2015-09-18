require 'java' # requires JRuby
require 'rdf/vcf/jar/htsjdk-1.139.jar'
require 'rdf/vcf/jar/bzip2.jar'

require 'digest/md5'
require 'rdf'

module RDF; module VCF
  ##
  # VCF file record.
  #
  # This is a user-friendly wrapper for the HTSJDK implementation.
  #
  # @see https://github.com/samtools/htsjdk
  # @see https://samtools.github.io/htsjdk/javadoc/htsjdk/htsjdk/variant/variantcontext/VariantContext.html
  class Record
    include RDF
    java_import 'htsjdk.variant.variantcontext.VariantContext'

    FALDO = RDF::Vocabulary.new("http://biohackathon.org/resource/faldo#")

    VAR_BASE_URI = 'http://rdf.ebi.ac.uk/terms/ensemblvariation/%s'.freeze

    ##
    # @param [VariantContext] variant_context
    def initialize(variant_context, reader)
      @vcf = variant_context
      @reader = reader
    end

    ##
    # @return [String]
    def id
      @id ||= case (id = @vcf.getID)
        when '.'
          label = "%s:%s:%s-%s" % ['', @vcf.getChr, @vcf.getStart, @vcf.getEnd] # TODO: species
          ::Digest::MD5.hexdigest(label)
        else id
      end
    end

    ##
    # @return [String]
    def uri
      @uri ||= VAR_BASE_URI % self.id
    end

    ##
    # @return [String]
    def chromosome
      @vcf.getChr
    end

    def start
      @vcf.getStart
    end

    def stop
      @vcf.getEnd
    end

    ##
    # @return [Hash{String => String}]
    def attributes
      @vcf.getAttributes
    end

    ##
    # @return [String]
    def reference
      @reader.reference
    end

    ##
    # @return [String]
    def file_date
      @reader.file_date
    end

    ##
    # @return [String]
    def source
      @reader.source
    end

    ##
    # @return [URI]
    def ref_base_uri
      @reader.ref_base_uri
    end


    def get_alleles(&block)
      @vcf.getAlleles.each do |allele|
        block.call(allele)
      end
    end

    def get_alternate_alleles(&block)
      @vcf.getAlternateAlleles.each do |allele|
        block.call(allele)
      end
    end
    ##
    # @return [String]
    def get_reference_allele
      @vcf.getReference.getBaseString
    end

    ##
    # @return [String]
    # def get_alternate_allele
    #   @vcf.getAlternateAlleles.first.getBaseString
    # end

    ##
    # @return [Double]
    def get_phred_scaled_qual
      @vcf.getPhredScaledQual
    end

    ##
    # @return [RDF::Graph]
    def to_rdf
      var_uri = RDF::URI(self.uri)
      RDF::Graph.new do |graph|
        graph << [var_uri, RDF::DC.identifier, self.id]
        graph << [var_uri, RDF::RDFS.label, self.id]
        graph << [self.ref_base_uri,DC.identifier,self.id]
        faldoRegion = ref_base_uri+":#{self.start}-#{self.stop}:1"
        graph << [var_uri,FALDO.location,faldoRegion]
        graph << [faldoRegion,RDFS.label,"#{self.id}:#{self.start}-#{self.stop}:1"]
        graph << [faldoRegion,RDF.type,FALDO.Region]
        graph << [faldoRegion,FALDO.begin,self.ref_base_uri+":#{self.start}:1"]
        graph << [faldoRegion,FALDO.end,self.ref_base_uri+":#{self.stop}:1"]
        graph << [faldoRegion,FALDO.reference,self.ref_base_uri]
        if self.start == self.stop
          faldoExactPosition = self.ref_base_uri+":#{self.start}:1"
          graph << [faldoExactPosition,RDF.type,"faldo:ExactPosition"]
          graph << [faldoExactPosition,RDF.type,"faldo:ForwardStrandPosition"]
          graph << [faldoExactPosition,FALDO.position,self.start]
          graph << [faldoExactPosition,FALDO.reference,self.ref_base_uri]
        end

        # TODO check if there are multiple alleles and iterate over them
        # TODO what happends if there is an insertion?
        refAlleleURI = var_uri+"\##{get_reference_allele}"
        graph << [var_uri,var_uri+":has_allele",refAlleleURI]
        graph << [refAlleleURI,RDFS.label,"#{self.id} allele #{get_reference_allele}"]
        graph << [refAlleleURI,RDF.type,var_uri+":reference_allele"]
        self.get_alternate_alleles do |altAllele|
          altAlleleURI = var_uri+"\##{altAllele.getBaseString}"
          graph << [var_uri,var_uri+":has_allele",altAlleleURI]
          graph << [altAlleleURI,RDFS.label,"#{self.id} allele #{altAllele.getBaseString}"]
          graph << [altAlleleURI, RDF.type, var_uri+":ancestral_allele"]

        end
        graph << [var_uri,URI(VAR_BASE_URI % "/vcf/quality"), RDF::Literal(get_phred_scaled_qual)]

        @vcf.attributes.each do |k, v|
          graph << [var_uri, RDF::URI( VAR_BASE_URI % "vcf/attribute\##{k}"), v] if v
        end

      end #new graph

    end #to_rdf
  end # Record
end; end # RDF::VCF
