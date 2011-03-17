require 'mkmf'

$CFLAGS << ' -std=c99 -fobjc-gc -flat_namespace -undefined suppress'
$LIBS << ' -framework Cocoa '

create_makefile('objective_bacon')
