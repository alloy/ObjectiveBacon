framework 'Cocoa'

if ENV['USE_OBJECTIVE_BACON_FRAMEWORK']
  # mainly for testing the framework with MacRuby
  framework 'ObjectiveBacon'
else
  require "objective_bacon"
end

module Kernel
  private

  def describe(*args, &block)
    context = BaconContext.alloc.initWithName(args.join(' '))
    context.instance_eval(&block)
    context
  end

  def shared(name, &block)
    BaconContext::Shared[name] = block
  end
end

class BaconContext
  Shared = Hash.new { |_, name|
    raise NameError, "no such context: #{name.inspect}"
  }

  def describe(*args, &block)
    context = childContextWithName(args.join(' '))
    parent_context = self
    context_metaclass = (class << context; self; end)
    parent_context.methods(false).each do |name|
      context_metaclass.send(:define_method, name) { |*args| parent_context.send(name, *args) }
    end
    context.instance_eval(&block)
    context
  end

  def before(&block)
    addBeforeFilter(block)
  end

  def after(&block)
    addAfterFilter(block)
  end

  def it(description, &block)
    addSpecification(description, withBlock:block, report:true)
  end

  def behaves_like(*names)
    names.each { |name| instance_eval(&Shared[name]) }
  end

  def wait(seconds = nil, &block)
    if seconds
      currentSpecification.scheduleBlock(block, withDelay:seconds)
    else
      currentSpecification.postponeBlock(block)
    end
  end

  def wait_max(timeout, &block)
    currentSpecification.postponeBlock(block, withTimeout:timeout)
  end

  def wait_for_change(observable, key_path, timeout = nil, &block)
    if timeout
      currentSpecification.postponeBlockUntilChange(block, ofObject:observable, withKeyPath:key_path, timeout:timeout)
    else
      currentSpecification.postponeBlockUntilChange(block, ofObject:observable, withKeyPath:key_path)
    end
  end

  def evaluateBlock(block)
    instance_eval(&block)
  end

  # UIBacon shortcuts

  def VV(class_or_path)
    app = NSApplication.sharedApplication
    window = app.keyWindow || app.windows.first
    if class_or_path.is_a?(Class)
      window.contentView.viewsByClass(class_or_path)
    else
      puts "TODO!"
    end
  end
end

class BaconShould
  # Kills ==, ===, =~, eql?, equal?, frozen?, instance_of?, is_a?,
  # kind_of?, nil?, respond_to?, tainted?
  Object.instance_methods.each do |name|
    if name =~ /\?|^\W+$/
      class_eval %{
        def #{name}(*a, &b)
          method_missing(#{name.inspect}, *a, &b)
        end
      }
    end
  end

  # TODO
  #alias_method :identical_to, :equal?
  #alias_method :same_as, :equal?

  def satisfy(&block)
    satisfy(nil, block:block)
  end

  def close(to, delta = nil)
    if delta
      closeTo(to, delta:delta)
    else
      closeTo(to)
    end
  end

  def match(value)
    satisfy("match #{value.inspect}", block:proc { |o| o =~ value })
  end
  alias_method :=~, :match

  def method_missing(method, *args, &block)
    method_name = method.to_s
    description = descriptionForMissingMethod(method_name, arguments:args)

    if object.respond_to?(method)
      # forward the message as-is
      satisfy(description, block:proc { |o| o.send(method, *args, &block) })
    else
      predicate = "#{method_name}?"
      if object.respond_to?(predicate)
        # forward the Ruby predicate version of the method
        satisfy(description, block:proc { |o| o.send(predicate, *args, &block) })
      else
        predicate = predicateVersionOfMissingMethod(method_name, arguments:args)
        if object.respond_to?(predicate)
          # forward the Objective-C predicate version of the method
          satisfy(description, block:proc { |o| o.send(predicate, *args) })
        else
          third_person_form = thirdPersonVersionOfMissingMethod(method_name, arguments:args)
          if object.respond_to?(third_person_form)
            # forward the Objective-C third person form of the method
            satisfy(description, block:proc { |o| o.send(third_person_form, *args) })
          else
            super
          end
        end
      end
    end
  end

  # Client overrides

  def prettyPrint(object)
    object.inspect
  end

  def isBlock(object)
    object.is_a?(Proc)
  end

  def convertException(exception)
    if info = exception.userInfo
      if rubyException = info.valueForKey('RubyException')
        return rubyException
      end
    end
    exception
  end

  def executeBlock(block)
    block.call
  end

  # We should not return 0/1/nil etc, but always strict boolean values.
  def executeAssertionBlock(block)
    !!block.call(object)
  end
end

class BaconSummary
  def formatExceptionBacktrace(exception)
    # TODO iirc, this can be nil/empty in the case of a pure objc exception
    if (bt = exception.backtrace) && !bt.empty?
      bt = bt.reject { |l| l =~ /(mac_bacon|macbacon)/ } unless $DEBUG
      "\t#{bt.join("\n\t")}"
    end
  end
end

class UIBaconViewSet
  alias_method :[], :index

  include Enumerable
  def each(&block)
    array.each(&block)
  end

  def inspect
    array.inspect
  end

  # TODO a MacRuby workwround, because it does not send a forwardInvocation message
  # even if methodSignatureForSelector implemented in objective-c returns a sig.
  # So force it to work as normal, overriding the imp from UIBaconViewSet.
  def methodSignatureForSelector(selector)
    super(selector)
  end

  def method_missing(method, *args, &block)
    viewSet = self.array
    if viewSet.first.respond_to?(method)
      _filteredList(viewSet.valueForKey(method))
    else
      super
    end
  end
end

class UIBaconPath
  def self.evalVariable(variable)
    eval variable
  end
end

class Proc
  def throw?(sym)
    catch(sym) {
      call
      return false
    }
    return true
  end
end
