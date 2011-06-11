#import "UIBacon.h"
#import "UIBaconPath.h"

#if TARGET_OS_IPHONE
#import "UIEventExtensions.h"
#endif

@implementation UIBacon

static BACON_WINDOW *sharedWindow = nil;

+ (BACON_WINDOW *)sharedWindow {
  if (sharedWindow == nil) {
#if TARGET_OS_IPHONE
    sharedWindow = [[UIApplication sharedApplication] keyWindow];
#else
    sharedWindow = [[NSApplication sharedApplication] keyWindow];
#endif
  }
  return sharedWindow;
}

+ (void)setSharedWindow:(BACON_WINDOW *)window {
  sharedWindow = window;
}

@end


@implementation UIBaconViewSet


- (id)initWithArray:(NSArray *)array {
  if ((self = [super init])) {
    viewSet = [[array sortedArrayUsingComparator:^(id view1, id view2) {
      CGPoint origin1 = [(BACON_VIEW *)view1 convertPoint:((BACON_VIEW *)view1).bounds.origin toView:nil];
      CGPoint origin2 = [(BACON_VIEW *)view2 convertPoint:((BACON_VIEW *)view2).bounds.origin toView:nil];
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

- (void)dealloc {
  [viewSet release];
  [super dealloc];
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

@interface BACON_VIEW (UIBaconPrivate)
- (CGPoint)carbonScreenPointFromCocoaScreenPoint:(NSPoint)cocoaPoint;
@end

@implementation BACON_VIEW (UIBacon)

// Sorts all views by their origin in the window.
- (UIBaconViewSet *)viewsByClass:(Class)viewClass {
  return [[[UIBaconViewSet alloc] initWithArray:[self _viewsByClass:viewClass recursive:YES]] autorelease];
}

- (NSArray *)_viewsByClass:(Class)viewClass recursive:(BOOL)recursive {
  NSMutableArray *result = [NSMutableArray array];
  for (BACON_VIEW *view in self.subviews) {
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
- (BACON_VIEW *)viewByName:(NSString *)accessibilityLabel {
  //NSLog(@"Search in: %@", self);
  for (BACON_VIEW *view in self.subviews) {
    NSString *label = nil;
#if TARGET_OS_IPHONE
    label = view.accessibilityLabel;
#else
    if (AXAPIEnabled()) {
      static AXUIElementRef appElement = NULL;
      if (appElement == NULL) {
        appElement = AXUIElementCreateApplication([[NSProcessInfo processInfo] processIdentifier]);
      }

      NSPoint origin = view.bounds.origin;
      if ([view isFlipped]) {
        // add vertical offset in case the view is flipped
        origin.y += view.bounds.size.height;
      }
      // convert to window coodinates
      origin = [view convertPointToBase:origin];
      // convert to screen coodinates
      origin = [view.window convertBaseToScreen:origin];
      // convert to Carbon screen point
      CGPoint screenLocation = [self carbonScreenPointFromCocoaScreenPoint:origin];

      AXUIElementRef element = NULL;
      if (AXUIElementCopyElementAtPosition(appElement, screenLocation.x, screenLocation.y, &element) == kAXErrorSuccess) {
        CFTypeRef title = NULL;
        if (AXUIElementCopyAttributeValue(element, kAXTitleAttribute, &title) == kAXErrorSuccess) {
          label = [(NSString *)title autorelease];
        }
        CFRelease(element);
      }
    } else {
      [NSException raise:@"AccessibilityError" format:@"To be able to find view elements, by their accessibility titles, accessibility should be turned on"];
    }
#endif
    if (label && [label isEqualToString:accessibilityLabel]) {
      return view;
    } else {
      BACON_VIEW *found = [view viewByName:accessibilityLabel];
      if (found) {
        return found;
      }
    }
  }
  return nil;
}

// Taken from the Apple UIElementInspector sample code
- (CGPoint)carbonScreenPointFromCocoaScreenPoint:(NSPoint)cocoaPoint {
  NSScreen *foundScreen = nil;
  CGPoint thePoint;

  for (NSScreen *screen in [NSScreen screens]) {
    if (NSPointInRect(cocoaPoint, [screen frame])) {
      foundScreen = screen;
    }
  }

  if (foundScreen) {
    CGFloat screenHeight = [foundScreen frame].size.height;
    thePoint = CGPointMake(cocoaPoint.x, screenHeight - cocoaPoint.y - 1);
  } else {
    thePoint = CGPointMake(0.0, 0.0);
  }

  return thePoint;
}

- (id)viewsByPath:(NSString *)path {
  return [UIBaconPath viewsByPath:path ofView:self];
}

#if TARGET_OS_IPHONE
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
#endif

@end
