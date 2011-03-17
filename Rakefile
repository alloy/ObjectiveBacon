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
      rm_rf 'build'
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

IOS_RUNNER_ROOT = 'NuBacon/iOSRunner'

namespace :ios do
  desc 'Create the spec runner'
  task :compile do
    Dir.chdir(IOS_RUNNER_ROOT) do
      sh 'xcodebuild -project NuBacon-iOSRunner.xcodeproj -target NuBacon-iOSRunner -configuration Debug -sdk /Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator4.2.sdk'
    end
  end

  desc 'Clean iOS build'
  task :clean do
    Dir.chdir(IOS_RUNNER_ROOT) do
      rm_rf 'build'
    end
  end

  namespace :spec do
    def run_on_ios_sim(family)
      path = `which ios-sim`.strip
      if path.empty?
        puts "[!] Unable to run the iOS simulator specs with ios-sim installed. Try `brew install ios-sim'."
      else
        sh "#{path} launch #{File.join(IOS_RUNNER_ROOT, 'build/Debug-iphonesimulator/NuBacon-iOSRunner.app')} --family #{family}"
      end
    end

    desc 'Run iOS specs on iPhone simulator'
    task :iphone => 'ios:compile' do
      run_on_ios_sim :iphone
    end

    desc 'Run iOS specs on iPad simulator'
    task :ipad => 'ios:compile' do
      run_on_ios_sim :ipad
    end
  end

  desc 'Run iOS specs'
  task :spec => ['ios:spec:iphone', 'ios:spec:ipad']
end

desc 'Clean all'
task :clean => ['macruby_ext:clean', 'framework:clean', 'ios:clean']

desc 'Run MacRuby ext, MacRuby framework, and Nu framework specs'
task :spec => ['macruby_ext:spec', 'framework:macruby_spec', 'framework:nu_spec', 'ios:spec']

task :default => :spec
