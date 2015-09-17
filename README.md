RDF::VCF
========

This is an [RDF.rb](https://github.com/ruby-rdf/rdf) reader plugin for
Variant Call Format (VCF) files, widely used in bioinformatics.

This project grew out of [BioHackathon 2014](http://2014.biohackathon.org/)
[work](https://github.com/dbcls/bh14/wiki/On-The-Fly-RDF-converter) by
[Raoul J.P. Bonnal](https://github.com/helios) and [Francesco
Strozzi](https://github.com/fstrozzi), and was further developed during
[BioHackathon 2015](http://2015.biohackathon.org/).

Note: at present, the project requires JRuby 9.0 (or newer) due to the
Java-based VCF parser.  We hope to eventually substitute
[Bio-vcf](https://github.com/pjotrp/bioruby-vcf) instead.

Features
========

* Implements an RDF.rb reader for VCF and BCF files, supporting also
  bgzipped files.
* Includes a CLI tool called `vcf2rdf` to transform VCF files into RDF.

Examples
========

Reading VCF Files
-----------------

The gem can be used like any other RDF.rb reader plugin:

    require 'rdf/vcf'

    RDF::VCF::Reader.open('Homo_sapiens.vcf.gz') do |reader|
      reader.each_statement do |statement|
        p statement
      end
    end

Command-Line Interface (CLI)
----------------------------

The gem includes a CLI tool called `vcf2rdf` which transforms VCF files into
RDF (currently, N-Triples):

    vcf2rdf Homo_sapiens.vcf.gz

Dependencies
============

* [JRuby](http://jruby.org) (>= 9.0)
* [RDF.rb](https://github.com/ruby-rdf/rdf) (>= 1.1)

Mailing List
============

* http://lists.w3.org/Archives/Public/public-rdf-ruby/

Authors
=======

* [Arto Bendiken](https://github.com/bendiken)
* [Raoul J.P. Bonnal](https://github.com/helios)
* [Francesco Strozzi](https://github.com/fstrozzi)

License
=======

This is free and unencumbered public domain software. For more information,
see <http://unlicense.org/> or the accompanying {file:UNLICENSE} file.
