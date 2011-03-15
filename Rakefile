EXT_SRC_ROOT = 'ext/objective_bacon'

desc 'Compile extension'
task :compile do
  Dir.chdir(EXT_SRC_ROOT) do
    sh 'macruby extconf.rb'
    sh 'make'
  end
end

desc 'Clean extension'
task :clean do
  Dir.chdir(EXT_SRC_ROOT) do
    sh 'rm -f Makefile'
    sh 'rm -f *.o'
    sh 'rm -f objective_bacon.bundle'
  end
end

desc 'Run specs'
task :spec => :compile do
  sh 'macruby spec/bacon_spec.rb'
  #sh 'macruby spec/mac_bacon_spec.rb'
end

task :default => :spec
