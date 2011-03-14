EXT_SRC_ROOT = 'ext/objective_bacon'

desc 'compile extension'
task :compile do
  Dir.chdir(EXT_SRC_ROOT) do
    sh 'macruby extconf.rb'
    sh 'make'
  end
end
