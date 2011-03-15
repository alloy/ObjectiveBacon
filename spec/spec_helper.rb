$:.unshift File.expand_path('../../lib', __FILE__)
$:.unshift File.expand_path('../../ext/objective_bacon', __FILE__)
require 'mac_bacon'

class BaconSpecification
  alias_method :_real_finish_spec, :finishSpec
end

class BaconContext
  def failures_before
    @failures_before
  end

  def expect_spec_to_fail!
    @failures_before = Bacon.sharedInstance.summary.failures
    BaconSpecification.class_eval do
      def finishSpec
        Bacon.sharedInstance.summary.failures.should == context.failures_before + 1
        Bacon.sharedInstance.summary.failures = context.failures_before
        self.class.class_eval { alias_method :finishSpec, :_real_finish_spec }
        _real_finish_spec
      end
    end
  end
end
