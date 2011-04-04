# -*- encoding: utf-8 -*-
$:.push('lib')
require "mac_bacon/version"

Gem::Specification.new do |s|
  s.name     = "mac_bacon"
  s.version  = Bacon::VERSION.dup
  s.date     = "2011-04-04"
  s.summary  = "A small RSpec clone, with NSRunLoop powers"
  s.email    = "eloy.de.enige@gmail.com"
  s.homepage = "https://github.com/alloy/ObjectiveBacon"
  s.authors  = ['Eloy Duran']
  
  s.description = <<-EOF
Bacon is a small RSpec clone weighing less than 350 LoC but nevertheless providing all essential features. This MacBacon fork differs with regular Bacon in that it operates properly in a NSRunloop based environment. I.e. MacRuby/Objective-C.
EOF
  
  s.files         = Dir['**/*'].reject { |f| %w{ .o .bundle }.include?(File.extname(f)) }
  s.test_files    = Dir['spec/**/*']
  #s.executables   = Dir['bin/*'].map { |f| File.basename(f) }
  s.require_paths = %w{ ext lib }
  s.extensions    = %w{ ext/extconf.rb }
  
  s.required_ruby_version = Gem::Requirement.new("~> 1.9")
  
  ## Make sure you can build the gem on older versions of RubyGems too:
  s.rubygems_version = "1.6.2"
  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.specification_version = 3 if s.respond_to? :specification_version
end
