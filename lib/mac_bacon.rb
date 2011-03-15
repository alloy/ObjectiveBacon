require "objective_bacon"

puts "HIER!"

module Kernel
  private

  def describe(*args, &block)
    context = BaconContext.alloc.initWithName(args.join(' '))
    context.instance_eval(&block)
    context
  end

  def shared(name, &block)
    # TODO
    #Bacon::Shared[name] = block
  end
end

class BaconContext
  def describe(*args, &block)
    context = childContextWithName(args.join(' '))
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
    # TODO
  end

  def evaluateBlock(block)
    instance_eval(&block)
  end
end

class BaconShould
  alias_method :==, :equal

  def satisfy(&block)
    satisfy(nil, block:block)
  end

  def method_missing(method, *args, &block)
    method_name = method.to_s
    description = descriptionForMissingMethod(method_name, arguments:args)

    if object.respond_to?(method)
      # forward the message as-is
      satisfy(description, block:proc { object.send(method, *args, &block) })
    else
      predicate = "#{method_name}?"
      if object.respond_to?(predicate)
        # forward the Ruby predicate version of the method
        satisfy(description, block:proc { object.send(predicate, *args, &block) })
      else
        predicate = predicateVersionOfMissingMethod(method_name, arguments:args)
        if object.respond_to?(predicate)
          # forward the Objective-C predicate version of the method
          satisfy(description, block:proc { object.send(predicate, *args) })
        else
          third_person_form = thirdPersonVersionOfMissingMethod(method_name, arguments:args)
          if object.respond_to?(third_person_form)
            # forward the Objective-C third person form of the method
            satisfy(description, block:proc { object.send(third_person_form, *args) })
          else
            super
          end
        end
      end
    end
  end

  #def getExceptionName(exception_class)
    #exception_class.name
  #end

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

  def executeBlock(block, withObject:object)
    block.call(object)
  end
end
