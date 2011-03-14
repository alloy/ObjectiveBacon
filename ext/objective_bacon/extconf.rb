require 'mkmf'

$CFLAGS << ' -fobjc-gc -flat_namespace -undefined suppress'
$LIBS << ' -framework Foundation '

create_makefile('objective_bacon')
