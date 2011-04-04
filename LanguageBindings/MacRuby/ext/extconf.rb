unless defined?(RUBY_ENGINE) && RUBY_ENGINE == "macruby"
  raise "The MacBacon gem is a MacRuby only gem."
end

require 'mkmf'

$CFLAGS << ' -std=c99 -fobjc-gc -flat_namespace -undefined suppress'
$LIBS << ' -framework Cocoa '

create_makefile('objective_bacon')
