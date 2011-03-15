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

  #def getExceptionName(exception_class)
    #exception_class.name
  #end

  def executeBlock(block)
    block.call
  end

  def executeBlock(block, withObject:object)
    block.call(object)
  end
end
