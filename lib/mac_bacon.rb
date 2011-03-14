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
  def satisfy(&block)
    satisfy(nil, block:block)
  end

  def executeBlock(block)
    block.call
  end

  def executeBlock(block, withObject:object)
    r = block.call(object)
    p r
    r
  end
end
