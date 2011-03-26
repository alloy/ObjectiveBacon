(global UIButtonTypeRoundedRect 1)
(global UIControlStateNormal 0)
(global UIControlContentVerticalAlignmentCenter 0)
(global UIControlContentVerticalAlignmentTop 1)

(class ColoredView is UIView)

(class ControlsViewController is UIViewController
  (ivar (id) viewWithSubviews)

  (ivar-accessors)

  (- (id)loadView is
    (set view (UIView new))
    (self setView:view)

    (set button (UIButton buttonWithType:UIButtonTypeRoundedRect))
    (button setTitle:"Button 1" forState:UIControlStateNormal)
    (button setFrame:`(0 0 80 30))
    (view addSubview:button)

    (set aSubview ((ColoredView alloc) initWithFrame:`(90, 15, 100, 100)))
    (aSubview setBackgroundColor:(UIColor redColor))
    (aSubview setAccessibilityLabel:"red's view")
    (view addSubview:aSubview)

    (set button (UIButton buttonWithType:UIButtonTypeRoundedRect))
    (button setTitle:"Button 3" forState:UIControlStateNormal)
    (button setFrame:`(10 35 80 30))
    (aSubview addSubview:button)

    (set button (UIButton buttonWithType:UIButtonTypeRoundedRect))
    (button setTitle:"Button 2" forState:UIControlStateNormal)
    (button setFrame:`(200 10 80 30))
    (view addSubview:button)

    (set button (UIButton buttonWithType:UIButtonTypeRoundedRect))
    (button setTitle:"Button 4" forState:UIControlStateNormal)
    (button setFrame:`(150 200 80 30))
    (view addSubview:button)

    (set @viewWithSubviews ((ColoredView alloc) initWithFrame:`(10, 300, 150, 150)))
    (@viewWithSubviews setBackgroundColor:(UIColor blueColor))
    (@viewWithSubviews setAccessibilityLabel:"blue view")
    (view addSubview:@viewWithSubviews)

    (set aSubview ((ColoredView alloc) initWithFrame:`(25, 25, 100, 100)))
    (aSubview setAccessibilityLabel:"green view")
    (aSubview setBackgroundColor:(UIColor greenColor))
    (@viewWithSubviews addSubview:aSubview)

    (set button (UIButton buttonWithType:UIButtonTypeRoundedRect))
    (button setTitle:"Button 6" forState:UIControlStateNormal)
    (button setFrame:`(10 35 80 30))
    (aSubview addSubview:button)

    (set button (UIButton buttonWithType:UIButtonTypeRoundedRect))
    (button setTitle:"Button 5" forState:UIControlStateNormal)
    (button setFrame:`(200 300 80 30))
    (view addSubview:button)
  )
)

(describe "Bacon UIView additions" `(
  (before (do ()
    (set @controller (ControlsViewController new))
    ($window setRootViewController:@controller)
    (wait 1 (do ()
      (set @view (@controller view))
    ))
  ))

  (after (do ()
    ($window setRootViewController:nil)
  ))

  (describe "viewsByClass:" `(
    (before (do ()
      (set @allButtons ((@controller view) viewsByClass:UIButton))
    ))

    (it "returns a UIBaconViewSet" (do ()
      (~ @allButtons should be kindOfClass:UIBaconViewSet)
      (~ (@allButtons count) should be:6)
      (~ ((@allButtons index:1) currentTitle) should equal:"Button 2")
      ; method forwarding
      (~ (@allButtons currentTitle) should equal:`("Button 1" "Button 2" "Button 3" "Button 4" "Button 5" "Button 6"))
      (~ (@allButtons currentImage) should equal:`(() () () () () ())) ; nil
      (~ (@allButtons buttonType) should equal:`(1 1 1 1 1 1))
    ))

    (it "returns subviews from any level down" (do ()
      (~ (((@controller viewWithSubviews) viewsByClass:UIButton) currentTitle) should equal:`("Button 6"))
    ))

    (it "returns subviews ordered from top-left to bottom-right" (do ()
      (~ (@allButtons currentTitle) should equal:`("Button 1" "Button 2" "Button 3" "Button 4" "Button 5" "Button 6"))
    ))

    (it "has `$$' as a shortcut for getting views from the key window" (do ()
      (~ ($$ UIButton) should equal:@allButtons)
    ))
  ))

  (describe "viewsByPath:" `(
    (it "finds a view by accessibility label if the start of the path is enclosed by single quotes" (do ()
      (~ (@view viewsByPath:"'green view'") should be:($ "green view"))
      (~ (@view viewsByPath:"'purple view'") should be:nil)
      (~ (($ "blue view") viewsByPath:"'green view'") should be:($ "green view"))
      (~ (($ "green view") viewsByPath:"'blue view'") should be:nil)
    ))

    (it "allows escaped single quotes in the accessibility label" (do ()
      (~ (@view viewsByPath:"'red\'s view'") should be:($ "red's view"))
    ))

    (it "raises an exception when a label is empty or unclosed" (do ()
      ;(puts ((@controller view) viewsByPath:"''/UIButton"))
      ;(puts ((@controller view) viewsByPath:"'//UIButton"))
      ;(puts ((@controller view) viewsByPath:"'green view/UIButton"))
    ))

    (it "finds a view by class" (do ()
      (~ ((@view viewsByPath:"UIButton") currentTitle) should be:`("Button 1" "Button 2" "Button 4" "Button 5"))
      (~ (($ "red's view") viewsByPath:"UIButton") should be:(NSArray arrayWithObject:($ "Button 3")))
    ))

    (it "finds classes only one down or any depth with double slash" (do ()
      (~ ((@view viewsByPath:"/UIButton") currentTitle) should be:`("Button 1" "Button 2" "Button 4" "Button 5"))
      (~ (@view viewsByPath:"//UIButton") should be:($$ UIButton))
    ))

    (it "retrieves one element of a set with a numerical accessor" (do ()
      (~ ((@view viewsByPath:"/UIButton[2]") currentTitle) should be:"Button 4")
      (~ ((@view viewsByPath:"//UIButton[2]") currentTitle) should be:"Button 3")
      (~ (@view viewsByPath:"//UIButton[42]") should be:nil)
    ))

    (it "returns all subviews with an asterisk (wildcard)" (do ()
      (~ (@view viewsByPath:"/*") should be:((UIBaconViewSet alloc) initWithArray:(@view subviews)))
      (~ (@view viewsByPath:"//*") should be:(@view viewsByClass:UIView))
    ))

    (after (do ()
      (($ "Button 2") setHidden:nil)
      (($ "Button 2") setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter)
    ))

    (it "selects elements matching the value for the given property key" (do ()
      (~ ((@view viewsByPath:"/UIButton[@currentTitle='Button 4'][0]") currentTitle) should be:"Button 4")
      (~ (@view viewsByPath:"/UIButton[0][@currentTitle='Button 4']") should be:nil)
      (~ ((@view viewsByPath:"/UIButton[2][@currentTitle='Button 4']") currentTitle) should be:"Button 4")
      (~ (@view viewsByPath:"/ColoredView[0][@accessibilityLabel='red\'s view']") should be:($ "red's view"))

      (~ (@view viewsByPath:"//UIButton[@hidden=true]") should be empty)
      (($ "Button 2") setHidden:t)
      (~ ((@view viewsByPath:"//UIButton[@hidden=true]") currentTitle) should be:`("Button 2"))
      (~ ((@view viewsByPath:"//UIButton[@hidden=false]") currentTitle) should be:`("Button 1" "Button 3" "Button 4" "Button 5" "Button 6"))

      (~ (@view viewsByPath:"//UIButton[@contentVerticalAlignment=UIControlContentVerticalAlignmentCenter]") should be:($$ UIButton))
      (~ (@view viewsByPath:"//UIButton[@contentVerticalAlignment=UIControlContentVerticalAlignmentTop]") should be empty)
      (($ "Button 2") setContentVerticalAlignment:UIControlContentVerticalAlignmentTop)
      (~ ((@view viewsByPath:"//UIButton[@contentVerticalAlignment=UIControlContentVerticalAlignmentTop]") currentTitle) should be:`("Button 2"))
    ))

    (it "combines the various path components to select views down in the tree" (do ()
      (~ ((@controller view) viewsByPath:"'green view'/UIButton") should be:(NSArray arrayWithObject:($ "Button 6")))
      (~ ((@controller view) viewsByPath:"'green view'/UIButton[0]") should be:($ "Button 6"))
      (~ ($$ (@controller view) "'green view'/UIButton[0]") should be:($ "Button 6"))

      (~ ((@controller view) viewsByPath:"'red\'s view'/UIButton") should be:(NSArray arrayWithObject:($ "Button 3")))
      (~ ((@controller view) viewsByPath:"'red\'s view'/UIButton[0]") should be:($ "Button 3"))

      (~ ((@controller view) viewsByPath:"'blue view'/UIView/UIButton") should be:(NSArray arrayWithObject:($ "Button 6")))
      (~ ((@controller view) viewsByPath:"'blue view'/UIView[0]/UIButton[0]") should be:($ "Button 6"))

      (~ ((@controller view) viewsByPath:"'blue view'//UIButton") should be:(NSArray arrayWithObject:($ "Button 6")))
      (~ ((@controller view) viewsByPath:"'blue view'//UIButton[0]") should be:($ "Button 6"))

      (~ ((@controller view) viewsByPath:"//UIButton") should be:($$ UIButton))
      (~ ((@controller view) viewsByPath:"//UIButton[1]") should be:($ "Button 2"))

      (~ ((@controller view) viewsByPath:"'blue view'/*") should be:(NSArray arrayWithObject:($ "green view")))
      (~ ((@controller view) viewsByPath:"'blue view'//*") should be:(($ "blue view") viewsByClass:UIView))

      (set views (NSMutableArray array))
      (views addObject:($ "Button 3"))
      (views addObject:($ "green view"))
      (views addObject:($ "Button 6"))
      (~ (@view viewsByPath:"//ColoredView/*") should be:views)
      (~ (@view viewsByPath:"//*") should be:(@view viewsByClass:UIView))

      (~ (@view viewsByPath:"//ColoredView/*[1]") should be:($ "green view"))
      (~ (@view viewsByPath:"//ColoredView/*/UIButton[0]") should be:($ "Button 6"))

      (~ ((@controller view) viewsByPath:"'blue view'/UIButton") should be:nil)
      (~ ((@controller view) viewsByPath:"'blue view'/UIButton[0]") should be:nil)
    ))
  ))

  (describe "viewByName:" `(
    (it "returns a UIView at any level by `accessibilityLabel'" (do ()
      (~ (((@controller view) viewByName:"Button 3") currentTitle) should equal:"Button 3")
      (~ (((@controller view) viewByName:"Button 6") currentTitle) should equal:"Button 6")
    ))

    (it "has `$' as a shortcut for getting views from the key window" (do ()
      (~ (($ "Button 3") currentTitle) should equal:"Button 3")
      (~ (($ "Button 6") currentTitle) should equal:"Button 6")
      (~ ((($ "green view") subviews) objectAtIndex:0) should be:($ "Button 6"))
    ))
  ))
))
