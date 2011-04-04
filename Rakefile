OBJECTIVE_BACON_SOURCE = 'Source'

MACRUBY_ROOT      = 'LanguageBindings/MacRuby'
MACRUBY_RUN_SPECS = "macruby -r #{MACRUBY_ROOT}/spec/bacon_spec.rb -r #{MACRUBY_ROOT}/spec/mac_bacon_spec.rb -e 'Bacon.sharedInstance.run'"
MACRUBY_EXT       = "#{MACRUBY_ROOT}/ext"

namespace :macruby do
  desc 'Copy source files into MacRuby ext dir'
  task :copy_source do
    sh "cp #{OBJECTIVE_BACON_SOURCE}/*.* #{MACRUBY_EXT}/"
    sh "rm #{MACRUBY_EXT}/UIBacon*.*"
  end

  desc 'Compile extension'
  task :compile => :copy_source do
    Dir.chdir(MACRUBY_EXT) do
      sh 'macruby extconf.rb'
      sh 'make'
    end
  end

  desc 'Clean extension'
  task :clean do
    Dir.chdir(MACRUBY_EXT) do
      sh 'rm -f Makefile'
      sh 'rm -f *.h'
      sh 'rm -f *.m'
      sh 'rm -f *.o'
      sh 'rm -f objective_bacon.bundle'
    end
  end

  desc 'Run specs'
  task :spec => :compile do
    sh MACRUBY_RUN_SPECS
  end

  desc 'Build gem'
  task :gem => :copy_source do
    require File.join(MACRUBY_ROOT, 'lib/mac_bacon/version')
    Dir.chdir(MACRUBY_ROOT) do
      sh 'gem build mac_bacon.gemspec'
      sh 'mkdir -p pkg'
      sh "mv mac_bacon-#{Bacon::VERSION}.gem pkg"
    end
  end
end


FRAMEWORK_ROOT = File.expand_path('../Framework', __FILE__)

NU_ROOT = 'LanguageBindings/Nu'

namespace :framework do
  desc 'Create the framework'
  task :compile do
    Dir.chdir(FRAMEWORK_ROOT) do
      sh 'xcodebuild'
    end
  end

  desc 'Clean framework'
  task :clean do
    Dir.chdir(FRAMEWORK_ROOT) do
      rm_rf 'build'
    end
  end

  desc 'Run Macruby specs'
  task :macruby_spec => :compile do
    sh "env USE_OBJECTIVE_BACON_FRAMEWORK=true DYLD_FRAMEWORK_PATH=#{FRAMEWORK_ROOT}/build/Release #{MACRUBY_RUN_SPECS}"
  end

  desc 'Run Nu specs'
  task :nu_spec => :install do
    # TODO nush doesn't use the frameworks in DYLD_FRAMEWORK_PATH, so installing the framework for now
    #sh "env DYLD_FRAMEWORK_PATH=#{FRAMEWORK_ROOT}/build/Release nush -f ObjectiveBacon bacon_spec.nu"
    sh "nush #{File.join(NU_ROOT, 'spec/bacon_spec.nu')}"
  end

  desc 'Install framework'
  task :install => :compile do
    rm_rf '/Library/Frameworks/ObjectiveBacon.framework'
    cp_r File.join(FRAMEWORK_ROOT, 'build/Release/ObjectiveBacon.framework'), '/Library/Frameworks'
  end
end

IOS_RUNNER_ROOT = File.join(NU_ROOT, 'iOSRunner')

namespace :ios do
  desc 'Create the spec runner'
  task :compile do
    Dir.chdir(IOS_RUNNER_ROOT) do
      sh 'xcodebuild -project NuBacon-iOSRunner.xcodeproj -target NuBaconSpecs -configuration Debug -sdk /Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator4.2.sdk'
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
        sh "#{path} launch #{File.join(IOS_RUNNER_ROOT, 'build/Debug-iphonesimulator/NuBaconSpecs.app')} --family #{family}"
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

desc "Generate Source/UIBaconPath.m"
task :ragel do
  sh "ragel Source/UIBaconPath.m.rl -o Source/UIBaconPath.m"
end

desc 'Clean all'
task :clean => ['macruby:clean', 'framework:clean', 'ios:clean']

desc 'Run MacRuby ext, MacRuby framework, and Nu framework specs'
task :spec => ['macruby:spec', 'framework:macruby_spec', 'framework:nu_spec', 'ios:spec']

task :default => :spec
