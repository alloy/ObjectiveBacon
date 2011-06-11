#import "TargetConditionals.h"
#if TARGET_OS_IPHONE

#import "UIEventExtensions.h"

@implementation GSEventProxy
@end

@implementation PublicEvent
@end

@interface UIEvent (Creation)

- (id)_initWithEvent:(GSEventProxy *)fp8 touches:(id)fp12;

@end

//
// UIEvent (Synthesize)
//
// A category to allow creation of a touch event.
//
@implementation UIEvent (Synthesize)

- (id)initWithTouch:(UITouch *)touch
{
  CGPoint location = [touch locationInView:touch.window];
  GSEventProxy *gsEventProxy = [[GSEventProxy alloc] init];
  gsEventProxy->x1 = location.x;
  gsEventProxy->y1 = location.y;
  gsEventProxy->x2 = location.x;
  gsEventProxy->y2 = location.y;
  gsEventProxy->x3 = location.x;
  gsEventProxy->y3 = location.y;
  gsEventProxy->sizeX = 1.0;
  gsEventProxy->sizeY = 1.0;
  gsEventProxy->flags = ([touch phase] == UITouchPhaseEnded) ? 0x1010180 : 0x3010180;
  gsEventProxy->type = 3001;  

  //
  // On SDK versions 3.0 and greater, we need to reallocate as a
  // UITouchesEvent.
  //
  Class touchesEventClass = objc_getClass("UITouchesEvent");
  if (touchesEventClass && ![[self class] isEqual:touchesEventClass])
  {
    [self release];
    self = [touchesEventClass alloc];
  }

  self = [self _initWithEvent:gsEventProxy touches:[NSSet setWithObject:touch]];
  return self;
}

@end


@implementation UITouch (Synthesize)

//
// initInView:phase:
//
// Creats a UITouch, centered on the specified view, in the view's window.
// Sets the phase as specified.
//
- (id)initInView:(UIView *)view
{
  self = [super init];
  if (self != nil)
  {
    CGRect frameInWindow;
    if ([view isKindOfClass:[UIWindow class]])
    {
      frameInWindow = view.frame;
    }
    else
    {
      frameInWindow =
      [view.window convertRect:view.frame fromView:view.superview];
    }
    
    _tapCount = 1;
    _locationInWindow =
    CGPointMake(
          frameInWindow.origin.x + 0.5 * frameInWindow.size.width,
          frameInWindow.origin.y + 0.5 * frameInWindow.size.height);
    _previousLocationInWindow = _locationInWindow;
    
    UIView *target = [view.window hitTest:_locationInWindow withEvent:nil];
    
    _window = [view.window retain];
    _view = [target retain];
    _phase = UITouchPhaseBegan;
    _touchFlags._firstTouchForView = 1;
    _touchFlags._isTap = 1;
    _timestamp = [NSDate timeIntervalSinceReferenceDate];
  }
  return self;
}

//
// setPhase:
//
// Setter to allow access to the _phase member.
//
- (void)setPhase:(UITouchPhase)phase
{
  _phase = phase;
  _timestamp = [NSDate timeIntervalSinceReferenceDate];
}

//
// setPhase:
//
// Setter to allow access to the _locationInWindow member.
//
- (void)setLocationInWindow:(CGPoint)location
{
  _previousLocationInWindow = _locationInWindow;
  _locationInWindow = location;
  _timestamp = [NSDate timeIntervalSinceReferenceDate];
}

@end

#endif
