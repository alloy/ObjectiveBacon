
class ColoredView < NSView
  attr_accessor :backgroundColor

  def drawRect(rect)
    @backgroundColor.set
    NSRectFill(rect)
    super
  end

  include AccessibilityTitle
end

class ControlsViewController < NSViewController
  attr_reader :clickedButton, :viewWithSubviews

  def buttonWithTitle(title, frame:frame)
    button = NSButton.new
    button.bezelStyle = NSRoundedBezelStyle
    button.target = self
    button.action = 'buttonClicked:'
    button.title = title
    button.frame = frame
    button
  end

  def buttonClicked(sender)
    @clickedButton = sender
  end

  def loadView
    view = NSView.new
    self.view = view

    button = buttonWithTitle('Button 1', frame:NSMakeRect(0, 0, 80, 30))
    view.addSubview(button)

    subview = ColoredView.alloc.initWithFrame(NSMakeRect(90, 15, 100, 100))
    subview.backgroundColor = NSColor.redColor
    subview.accessibilityLabel = "red's view"
    view.addSubview(subview)

    button = buttonWithTitle('Button 3', frame:NSMakeRect(10, 35, 80, 30))
    subview.addSubview(button)

    button = buttonWithTitle('Button 2', frame:NSMakeRect(200, 10, 80, 30))
    view.addSubview(button)

    button = buttonWithTitle('Button 4', frame:NSMakeRect(150, 200, 80, 30))
    view.addSubview(button)

    @viewWithSubviews = ColoredView.alloc.initWithFrame(NSMakeRect(10, 300, 150, 150))
    @viewWithSubviews.backgroundColor = NSColor.blueColor
    @viewWithSubviews.accessibilityLabel = "blue view"
    view.addSubview(@viewWithSubviews)

    subview = ColoredView.alloc.initWithFrame(NSMakeRect(25, 25, 100, 100))
    subview.backgroundColor = NSColor.greenColor
    subview.accessibilityLabel = "green view"
    @viewWithSubviews.addSubview(subview)

    button = buttonWithTitle('Button 6', frame:NSMakeRect(10, 35, 80, 30))
    subview.addSubview(button)

    button = buttonWithTitle('Button 5', frame:NSMakeRect(200, 300, 80, 30))
    view.addSubview(button)
  end
end

describe "Bacon NSView additions" do
  before do
    @window = NSWindow.alloc.initWithContentRect([200, 300, 320, 480],
                                       styleMask:NSTitledWindowMask,
                                         backing:NSBackingStoreBuffered,
                                           defer:false)
    @controller = ControlsViewController.new
    @view = @controller.view
    @view.frame = NSMakeRect(0, 0, 320, 480)
    @window.contentView.addSubview(@view)
    @window.orderFrontRegardless
    @window.makeKeyWindow
    #wait 1 do
    #end
  end

  after do
    @window.close
  end

  describe "viewsByClass:" do
    before do
      @allButtons = @view.viewsByClass(NSButton)
    end

    it "returns a UIBaconViewSet" do
      @allButtons.should.be.instance_of UIBaconViewSet
      @allButtons.count.should.be 6
      @allButtons[1].title.should == 'Button 2'
      # method missing collects from the elements in the set
      @allButtons.bezelStyle.should == Array.new(6) { NSRoundedBezelStyle }
    end

    it "returns subviews from any level down" do
      @controller.viewWithSubviews.viewsByClass(NSButton).title.should == ["Button 6"]
    end

    it "returns subviews ordered from top-left to bottom-right" do
      @allButtons.title.should == Array.new(6) { |i| "Button #{i+1}" }
    end

    it "has `VV' as a shortcut for getting views from the key window or the first of the app's windows" do
      VV(NSButton).should == @allButtons
    end
  end

  describe "viewsByPath:" do
    it "finds a view by accessibility label if the start of the path is enclosed by single quotes" do
      @view.viewsByPath("'green view'").should == V("green view")
      @view.viewsByPath("'purple view'").should == nil
      V("blue view").viewsByPath("'green view'").should == V("green view")
      V("green view").viewsByPath("'blue view'").should == nil
    end

    it "allows escaped single quotes in the accessibility label" do
      @view.viewsByPath("'red\'s view'").should == V("red's view")
    end

    #it "raises an exception when a label is empty or unclosed" do
      
    #end

    it "finds a view by class" do
      @view.viewsByPath("/NSButton").title.should == ["Button 1", "Button 2", "Button 4", "Button 5"]
      V("red's view").viewsByPath("/NSButton").title.should == ["Button 3"]
    end

    it "finds classes only one down or any depth with double slash" do
      @view.viewsByPath("/NSButton").title.should == ["Button 1", "Button 2", "Button 4", "Button 5"]
      @view.viewsByPath("//NSButton").should == VV(NSButton)
    end

    it "retrieves one element of a set with a numerical accessor" do
      @view.viewsByPath("/NSButton[2]").title.should == "Button 4"
      @view.viewsByPath("/NSButton[-1]").title.should == "Button 5"
      @view.viewsByPath("/NSButton[-2]").title.should == "Button 4"
      @view.viewsByPath("//NSButton[2]").title.should == "Button 3"
      @view.viewsByPath("//NSButton[-1]").title.should == "Button 6"
      @view.viewsByPath("//NSButton[42]").should == nil
      @view.viewsByPath("//NSButton[-42]").should == nil
    end

    it "returns all subviews with an asterisk (wildcard)" do
      @view.viewsByPath("/*").should == UIBaconViewSet.alloc.initWithArray(@view.subviews)
      @view.viewsByPath("//*").should == @view.viewsByClass(NSView)
    end

    it "selects elements matching the value for the given property key" do
      button = V("Button 2")

      @view.viewsByPath("/NSButton[@title='Button 4'][0]").title.should == "Button 4"
      @view.viewsByPath("/NSButton[0][@title='Button 4']").should == nil
      @view.viewsByPath("/NSButton[2][@title='Button 4']").title.should == "Button 4"
      @view.viewsByPath("/ColoredView[0][@accessibilityLabel='red\'s view']").should == V("red's view")

      @view.viewsByPath("//NSButton[@hidden=true]").should.be.empty
      button.hidden = true
      @view.viewsByPath("//NSButton[@hidden=true]").title.should == ["Button 2"]
      @view.viewsByPath("//NSButton[@hidden=false]").title.should == ["Button 1", "Button 3", "Button 4", "Button 5", "Button 6"]

      @view.viewsByPath("//NSButton[@alignment=NSCenterTextAlignment]").should == VV(NSButton)
      @view.viewsByPath("//NSButton[@alignment=NSRightTextAlignment]").should.be.empty
      button.alignment = NSRightTextAlignment
      @view.viewsByPath("//NSButton[@alignment=NSRightTextAlignment]").title.should == ["Button 2"]

      @view.viewsByPath("//NSView[@class=NSButton]").should == VV(NSButton)
      @view.viewsByPath("//NSView[@class=NSButton][@alignment=NSRightTextAlignment]").title.should == ["Button 2"]
    end

    #it "combines the various path components to select views down in the tree" do
      
    #end
  end

  describe "viewByName:" do
    it "returns a NSView at any level by `AXTitle'" do
      @view.viewByName("Button 3").title.should == "Button 3"
      @view.viewByName("Button 6").title.should == "Button 6"
    end

    it "has `V' as a shortcut for getting views from the key window or the first of the app's windows" do
      V("Button 3").title.should == "Button 3"
      V("Button 6").title.should == "Button 6"
      V("green view").subviews[0].should == V("Button 6")
    end
  end
end
