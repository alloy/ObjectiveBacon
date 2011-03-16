RUN_MACRUBY_SPECS_CMD = 'macruby -r spec/bacon_spec.rb -r spec/mac_bacon_spec.rb -e "Bacon.sharedInstance.run"'

EXT_SRC_ROOT = 'ext/objective_bacon'

namespace :macruby_ext do
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
    sh RUN_MACRUBY_SPECS_CMD
  end
end


FRAMEWORK_ROOT = File.expand_path('../Framework', __FILE__)

namespace :framework do
  desc 'Create the framework'
  task :compile do
    Dir.chdir(FRAMEWORK_ROOT) do
      sh 'xcodebuild'
    end
  end

  desc 'Clean extension'
  task :clean do
    Dir.chdir(EXT_SRC_ROOT) do
      sh 'rm -f build'
    end
  end

  desc 'Run Macruby specs'
  task :macruby_spec => :compile do
    sh "env USE_OBJECTIVE_BACON_FRAMEWORK=true DYLD_FRAMEWORK_PATH=#{FRAMEWORK_ROOT}/build/Release #{RUN_MACRUBY_SPECS_CMD}"
  end

  desc 'Run Nu specs'
  task :nu_spec => :install do
    Dir.chdir('NuBacon') do
      # TODO nush doesn't use the frameworks in DYLD_FRAMEWORK_PATH, so installing the framework for now
      #sh "env DYLD_FRAMEWORK_PATH=#{FRAMEWORK_ROOT}/build/Release nush -f ObjectiveBacon bacon_spec.nu"
      sh "nush -f ObjectiveBacon bacon_spec.nu"
    end
  end

  desc 'Install framework'
  task :install => :compile do
    rm_rf '/Library/Frameworks/ObjectiveBacon.framework'
    cp_r File.join(FRAMEWORK_ROOT, 'build/Release/ObjectiveBacon.framework'), '/Library/Frameworks'
  end
end

desc 'Clean all'
task :clean => ['macruby_ext:clean', 'framework:clean']
