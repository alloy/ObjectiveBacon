(global UIButtonTypeRoundedRect 1)
(global UIControlStateNormal 0)

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

    (set aSubview ((UIView alloc) initWithFrame:`(90, 15, 100, 100)))
    (aSubview setBackgroundColor:(UIColor redColor))
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

    (set @viewWithSubviews ((UIView alloc) initWithFrame:`(10, 300, 150, 150)))
    (@viewWithSubviews setBackgroundColor:(UIColor blueColor))
    (view addSubview:@viewWithSubviews)

    (set aSubview ((UIView alloc) initWithFrame:`(25, 25, 100, 100)))
    (aSubview setBackgroundColor:(UIColor greenColor))
    (@viewWithSubviews addSubview:aSubview)

    (set button (UIButton buttonWithType:UIButtonTypeRoundedRect))
    (button setTitle:"Button 6" forState:UIControlStateNormal)
    (button setFrame:`(10 35 80 30))
    (@viewWithSubviews addSubview:button)

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
    (wait 1 (do () ))
  ))

  (after (do ()
    ($window setRootViewController:nil)
  ))

  (describe "viewsByClass:" `(
    (it "returns subviews from any level down" (do ()
      (set buttons ((@controller viewWithSubviews) viewsByClass:UIButton))
      (set titles ((buttons list) map:(do (b) (b currentTitle))))
      (~ titles should equal:`("Button 6"))
    ))

    (it "returns subviews ordered from top-left to bottom-right" (do ()
      (set buttons ((@controller view) viewsByClass:UIButton))
      (set titles ((buttons list) map:(do (b) (b currentTitle))))
      (~ titles should equal:`("Button 1" "Button 2" "Button 3" "Button 4" "Button 5" "Button 6"))
    ))
  ))
))
