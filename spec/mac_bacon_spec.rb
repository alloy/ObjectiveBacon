require File.expand_path('../spec_helper', __FILE__)

class MockObservable
  attr_accessor :an_attribute
end

describe "NSRunloop aware Bacon" do
  describe "concerning `wait' with a fixed time" do
    it "allows the user to postpone execution of a block for n seconds, which will halt any further execution of specs" do
      started_at_1 = started_at_2 = started_at_3 = Time.now
      number_of_specs_before = Bacon::Counter[:specifications]

      wait 0.5 do
        (Time.now - started_at_1).should.be.close(0.5, 0.5)
      end
      wait 1 do
        (Time.now - started_at_2).should.be.close(1, 0.5)
        wait 1.5 do
          (Time.now - started_at_3).should.be.close(2.5, 0.5)
          Bacon::Counter[:specifications].should == number_of_specs_before
        end
      end
    end
  end

  describe "concerning `wait' without a fixed time" do
    def delegateCallbackMethod
      @delegateCallbackCalled = true
      resume
    end

    it "allows the user to postpone execution of a block until Context#resume is called, from for instance a delegate callback" do
      performSelector('delegateCallbackMethod', withObject:nil, afterDelay:0.1)
      @delegateCallbackCalled.should == nil
      wait do
        @delegateCallbackCalled.should == true
      end
    end

    def delegateCallbackTookTooLongMethod
      raise "Oh noes, I must never be called!"
    end

    # This spec adds a failure to the ErrorLog!
    it "has a default timeout of 1 second after which the spec will fail and further scheduled calls to the Context are cancelled" do
      expect_spec_to_fail!
      performSelector('delegateCallbackTookTooLongMethod', withObject:nil, afterDelay:1.2)
      wait do
        # we must never arrive here, because the default timeout of 1 second will have passed
        raise "Oh noes, we shouldn't have arrived in this postponed block!"
      end
    end

    # This spec adds a failure to the ErrorLog!
    it "takes an explicit timeout" do
      expect_spec_to_fail!
      performSelector('delegateCallbackTookTooLongMethod', withObject:nil, afterDelay:0.8)
      wait_max 0.3 do
        # we must never arrive here, because the default timeout of 1 second will have passed
        raise "Oh noes, we shouldn't have arrived in this postponed block!"
      end
    end
  end

  describe "concerning `wait_for_change'" do
    before do
      @observable = MockObservable.new
    end

    def triggerChange
      @observable.an_attribute = 'changed'
    end

    it "resumes the postponed block once an observed value changes" do
      wait_for_change @observable, 'an_attribute' do
        @value = @observable.an_attribute
      end
      @value.should == nil
      performSelector('triggerChange', withObject:nil, afterDelay:0.1)
      wait 0.2 do
        @value.should == 'changed'
      end
    end

    # This spec adds a failure to the ErrorLog!
    it "has a default timeout of 1 second" do
      expect_spec_to_fail!
      wait_for_change(@observable, 'an_attribute') do
        raise "Oh noes, I must never be called!"
      end
      performSelector('triggerChange', withObject:nil, afterDelay:1.1)
      wait 1.2 do
        # we must never arrive here, because the default timeout of 1 second will have passed
        raise "Oh noes, we shouldn't have arrived in this postponed block!"
      end
    end

    # This spec adds a failure to the ErrorLog!
    it "takes an explicit timeout" do
      expect_spec_to_fail!
      wait_for_change(@observable, 'an_attribute', 0.3) do
        raise "Oh noes, I must never be called!"
      end
      performSelector('triggerChange', withObject:nil, afterDelay:0.8)
      wait 0.9 do
        # we must never arrive here, because the default timeout of 1 second will have passed
        raise "Oh noes, we shouldn't have arrived in this postponed block!"
      end
    end
  end

  describe "postponing blocks should work from before/after filters as well" do
    shared "waiting in before/after filters" do
      it "starts later because of postponed blocks in the before filter" do
        (Time.now - @started_at).should.be.close(1, 0.5)
      end

      it "starts even later because of the postponed blocks in the after filter" do
        (Time.now - @started_at).should.be.close(3, 0.5)
      end
    end

    describe "with `wait'" do
      describe "and an explicit time" do
        before do
          @started_at ||= Time.now
          wait 0.5 do
            wait 0.5 do
            end
          end
        end

        after do
          wait 0.5 do
            wait 0.5 do
              @time ||= 0
              @time += 2
              (Time.now - @started_at).should.be.close(@time, 0.2)
            end
          end
        end

        behaves_like "waiting in before/after filters"
      end

      describe "and without explicit time" do
        before do
          @started_at ||= Time.now
          performSelector('resume', withObject:nil, afterDelay:0.5)
          wait do
            performSelector('resume', withObject:nil, afterDelay:0.5)
            wait do
            end
          end
        end

        after do
          performSelector('resume', withObject:nil, afterDelay:0.5)
          wait do
            performSelector('resume', withObject:nil, afterDelay:0.5)
            wait do
              @time ||= 0
              @time += 2
              (Time.now - @started_at).should.be.close(@time, 0.2)
            end
          end
        end

        behaves_like "waiting in before/after filters"
      end
    end

    describe "with `wait_for_change'" do
      before do
        @observable = MockObservable.new
        @started_at ||= Time.now
        performSelector('triggerChange', withObject:nil, afterDelay:0.5)
        wait_for_change @observable, 'an_attribute' do
          performSelector('triggerChange', withObject:nil, afterDelay:0.5)
          wait_for_change @observable, 'an_attribute' do
          end
        end
      end

      after do
        performSelector('triggerChange', withObject:nil, afterDelay:0.5)
        wait_for_change @observable, 'an_attribute' do
          performSelector('triggerChange', withObject:nil, afterDelay:0.5)
          wait_for_change @observable, 'an_attribute' do
            @time ||= 0
            @time += 2
            (Time.now - @started_at).should.be.close(@time, 1)
          end
        end
      end

      def triggerChange
        @observable.an_attribute = 'changed'
      end

      behaves_like "waiting in before/after filters"
    end
  end
end

class WindowController < NSWindowController
  attr_accessor :arrayController
  attr_accessor :tableView
  attr_accessor :textField
end

describe "Nib helper" do
  def verify_outlets_of_owner(owner)
    owner.arrayController.should.be.instance_of NSArrayController
    owner.tableView.should.be.instance_of NSTableView
    owner.textField.should.be.instance_of NSTextField
  end

  it "takes a NIB path and instantiates the NIB with the given `owner' object" do
    nib_path = File.expand_path("../fixtures/Window.nib", __FILE__)
    owner = WindowController.new
    load_nib(nib_path, owner)
    verify_outlets_of_owner(owner)
  end

  it "also returns an array or other top level objects" do
    nib_path = File.expand_path("../fixtures/Window.nib", __FILE__)
    owner = WindowController.new
    top_level_objects = load_nib(nib_path, owner).sort_by { |o| o.class.name }
    top_level_objects[0].should.be.instance_of NSApplication
    top_level_objects[1].should.be.instance_of NSArrayController
    top_level_objects[2].should.be.instance_of NSWindow
  end

  it "converts a XIB to a tmp NIB before loading it and caches it" do
    xib_path = File.expand_path("../fixtures/Window.xib", __FILE__)
    owner = WindowController.new
    load_nib(xib_path, owner)
    verify_outlets_of_owner(owner)

    def self.system(cmd)
      raise "Oh noes! Tried to convert again!"
    end

    owner = WindowController.new
    load_nib(xib_path, owner)
    verify_outlets_of_owner(owner)
  end
end
