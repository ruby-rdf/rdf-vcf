RDF::VCF
========

This is an RDF.rb reader for Variant Call Format (VCF) files, widely used in
bioinformatics.

This project grew out of [BioHackathon 2014](http://2014.biohackathon.org/)
[work](https://github.com/dbcls/bh14/wiki/On-The-Fly-RDF-converter) by
[Raoul J.P.  Bonnal](https://github.com/helios) and [Francesco
Strozzi](https://github.com/fstrozzi), and was further developed during
[BioHackathon 2015](http://2015.biohackathon.org/).

Note: at present, the project requires JRuby due to the Java-based VCF parser.
We hope to eventually substitute [Bio-vcf](https://github.com/pjotrp/bioruby-vcf)
instead.

Command-Line Interface (CLI)
============================

The gem includes a CLI tool called `vcf2rdf` which transforms VCF files into
RDF (currently, N-Triples):

    vcf2rdf Homo_sapiens.vcf.gz
