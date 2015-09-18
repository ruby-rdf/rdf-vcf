#!/usr/bin/env ruby -rubygems
# -*- encoding: utf-8 -*-

Gem::Specification.new do |gem|
  gem.version            = File.read('VERSION').chomp
  gem.date               = File.mtime('VERSION').strftime('%Y-%m-%d')

  gem.name               = 'rdf-vcf'
  gem.homepage           = 'https://github.com/ruby-rdf/rdf-vcf'
  gem.license            = 'Public Domain' if gem.respond_to?(:license=)
  gem.summary            = 'RDF.rb reader for Variant Call Format (VCF) files.'
  gem.description        = <<-EOF
    This is an RDF.rb reader plugin for Variant Call Format (VCF) files,
    widely used in bioinformatics.
  EOF

  gem.authors            = ['Arto Bendiken', 'Raoul J.P. Bonnal', 'Francesco Strozzi']
  gem.email              = 'public-rdf-ruby@w3.org'

  gem.platform           = Gem::Platform::RUBY
  gem.files              = %w(AUTHORS CREDITS README UNLICENSE VERSION) + Dir.glob('lib/**/*.rb') + Dir.glob('lib/**/*.jar')
  gem.bindir             = %q(bin)
  gem.executables        = %w(vcf2rdf)
  gem.default_executable = gem.executables.first
  gem.require_paths      = %w(lib)
  gem.extensions         = %w()
  gem.test_files         = %w()
  gem.has_rdoc           = false

  gem.required_ruby_version      = '>= 2.2'
  gem.required_rubygems_version  = '>= 2.2'
  gem.requirements               = ['JRuby (>= 9.0)']
  gem.add_runtime_dependency     'rdf',   '~> 1.1'
  gem.add_development_dependency 'rake',  '~> 10'
  gem.add_development_dependency 'rspec', '~> 3'
  gem.add_development_dependency 'yard' , '~> 0.8'
  gem.post_install_message       = nil
end
