EXT_SRC_ROOT = 'ext/objective_bacon'

desc 'Compile extension'
task :compile do
  Dir.chdir(EXT_SRC_ROOT) do
    sh 'macruby extconf.rb'
    sh 'make'
  end
end

desc 'Run specs'
task :spec => :compile do
  sh 'macruby spec/bacon_spec.rb'
end

task :default => :spec
