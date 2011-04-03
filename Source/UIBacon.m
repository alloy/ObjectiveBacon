#import "UIBacon.h"
#import "UIBaconPath.h"


@implementation UIBacon

static UIWindow *sharedWindow = nil;

+ (UIWindow *)sharedWindow {
  if (sharedWindow == nil) {
    sharedWindow = [[UIApplication sharedApplication] keyWindow];
  }
  return sharedWindow;
}

+ (void)setSharedWindow:(UIWindow *)window {
  sharedWindow = window;
}

@end


@implementation UIBaconViewSet


- (id)initWithArray:(NSArray *)array {
  if (self = [super init]) {
    viewSet = [[array sortedArrayUsingComparator:^(id view1, id view2) {
      CGPoint origin1 = [(UIView *)view1 convertPoint:((UIView *)view1).bounds.origin toView:nil];
      CGPoint origin2 = [(UIView *)view2 convertPoint:((UIView *)view2).bounds.origin toView:nil];
      if (floor(origin1.y) > floor(origin2.y)) {
        return (NSComparisonResult)NSOrderedDescending;
      } else if (floor(origin1.y) < floor(origin2.y)) {
        return (NSComparisonResult)NSOrderedAscending;
      } else if (floor(origin1.x) > floor(origin2.x)) {
        return (NSComparisonResult)NSOrderedDescending;
      } else if (floor(origin1.x) < floor(origin2.x)) {
        return (NSComparisonResult)NSOrderedAscending;
      }
      return (NSComparisonResult)NSOrderedSame;
    }] retain];
  }
  return self;
}

- (NSArray *)array {
  return [viewSet autorelease];
}

- (NSUInteger)count {
  return [viewSet count];
}

- (BOOL)isEmpty {
  return [viewSet count] == 0;
}

- (id)index:(NSInteger)index {
  NSInteger i = index;
  if (i < 0) {
    i = [viewSet count] + i;
  }
  if (i < 0 || i + 1 > [viewSet count]) {
    return nil;
  }
  return [viewSet objectAtIndex:i];
}

- (NSString *)description {
  return [viewSet description];
}

- (BOOL)isEqual:(id)other {
  if ([other isKindOfClass:[UIBaconViewSet class]]) {
    return [viewSet isEqual:[other array]];
  } else {
    return [other isEqual:viewSet];
  }
}

// UIBaconViewSet methods

- (NSMethodSignature *)methodSignatureForSelector:(SEL)selector {
  // TODO Why doesn't this work?
  //NSMethodSignature *sig = [[viewSet objectAtIndex:0] methodSignatureForSelector:selector];
  //NSLog(@"sel: %s, sig: %@, args: %d", (char *)selector, sig, [sig numberOfArguments]);
  //if (sig && [sig numberOfArguments] == 0) {
  const char *sel = sel_getName(selector);
  if ([[viewSet objectAtIndex:0] respondsToSelector:selector] && sel[strlen(sel) - 1] != ':') {
    return [NSMethodSignature signatureWithObjCTypes:"@@:^v"];
  } else {
    return [super methodSignatureForSelector:selector];
  }
}

- (void)forwardInvocation:(NSInvocation *)invocation {
  SEL sel = [invocation selector];

  if ([[viewSet objectAtIndex:0] respondsToSelector:sel]) {
    id result = [self _filteredList:[viewSet valueForKey:NSStringFromSelector(sel)]];
    [invocation setReturnValue:&result];
  } else {
    [self doesNotRecognizeSelector:sel];
  }
}

// To be override by the client to return a suitable class other than NSArray.
- (id)_filteredList:(NSArray *)array {
  return (id)array;
}

@end


@implementation UIView (UIBacon)

// Sorts all views by their origin in the window.
- (UIBaconViewSet *)viewsByClass:(Class)viewClass {
  return [[[UIBaconViewSet alloc] initWithArray:[self _viewsByClass:viewClass recursive:YES]] autorelease];
}

- (NSArray *)_viewsByClass:(Class)viewClass recursive:(BOOL)recursive {
  NSMutableArray *result = [NSMutableArray array];
  for (UIView *view in self.subviews) {
    if ([view isKindOfClass:viewClass]) {
      [result addObject:view];
    }
    if (recursive) {
      [result addObjectsFromArray:[view _viewsByClass:viewClass recursive:YES]];
    }
  }
  return result;
}

// To be able to use this the simulator/device needs to have accessibility enabled.
// Do this in the Settings app.
- (UIView *)viewByName:(NSString *)accessibilityLabel {
  //NSLog(@"Search in: %@", self);
  for (UIView *view in self.subviews) {
    //NSLog(@"Label: %@", view.accessibilityLabel);
    if ([view.accessibilityLabel isEqualToString:accessibilityLabel]) {
      return view;
    } else {
      UIView *found = [view viewByName:accessibilityLabel];
      if (found) {
        return found;
      }
    }
  }
  return nil;
}

- (id)viewsByPath:(NSString *)path {
  return [UIBaconPath viewsByPath:path ofView:self];
}

- (void)touch {
  UITouch *touch = [[UITouch alloc] initInView:self];
  UIEvent *eventDown = [[UIEvent alloc] initWithTouch:touch];
  [touch.view touchesBegan:[eventDown allTouches] withEvent:eventDown];
  
  UIEvent *eventUp = [[UIEvent alloc] initWithTouch:touch];
  [touch setPhase:UITouchPhaseEnded];
  [touch.view touchesEnded:[eventUp allTouches] withEvent:eventUp];

  [eventDown release];
  [eventUp release];
  [touch release];
}

@end

//
//  TouchSynthesis.m
//  SelfTesting
//
//  Created by Matt Gallagher on 23/11/08.
//  Copyright 2008 Matt Gallagher. All rights reserved.
//
//  Permission is given to use this source code file, free of charge, in any
//  project, commercial or otherwise, entirely at your risk, with the condition
//  that any redistribution (in part or whole) of source code must retain
//  this copyright and permission notice. Attribution in compiled projects is
//  appreciated but not required.
//


//
// GSEvent is an undeclared object. We don't need to use it ourselves but some
// Apple APIs (UIScrollView in particular) require the x and y fields to be present.
//
@interface GSEventProxy : NSObject
{
@public
  unsigned int flags;
  unsigned int type;
  unsigned int ignored1;
  float x1;
  float y1;
  float x2;
  float y2;
  unsigned int ignored2[10];
  unsigned int ignored3[7];
  float sizeX;
  float sizeY;
  float x3;
  float y3;
  unsigned int ignored4[3];
}
@end
@implementation GSEventProxy
@end

//
// PublicEvent
//
// A dummy class used to gain access to UIEvent's private member variables.
// If UIEvent changes at all, this will break.
//
@interface PublicEvent : NSObject
{
@public
    GSEventProxy           *_event;
    NSTimeInterval          _timestamp;
    NSMutableSet           *_touches;
    CFMutableDictionaryRef  _keyedTouches;
}
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

@interface UITouch (Synthesize)

- (id)initInView:(UIView *)view;
- (void)setPhase:(UITouchPhase)phase;
- (void)setLocationInWindow:(CGPoint)location;

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
