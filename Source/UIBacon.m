#import "UIBacon.h"
#import "UIBaconPath.h"

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

- (id)index:(NSUInteger)index {
  return [viewSet objectAtIndex:index];
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
    } else {
      if (recursive) {
        [result addObjectsFromArray:[view _viewsByClass:viewClass recursive:YES]];
      }
    }
  }
  return result;
}

// To be able to use this the simulator/device needs to have accessibility enabled.
// Do this in the Settings app.
- (UIView *)viewByName:(NSString *)accessibilityLabel {
  UIView *result = [self _viewByName:accessibilityLabel];
  if (!result) {
    printf("[!] Unable to find a view by accessibility label `%s'. Did you enable accessibility on the device/simulator?\n", [accessibilityLabel UTF8String]);
  }
  return result;
}

- (UIView *)_viewByName:(NSString *)accessibilityLabel {
  //NSLog(@"Search in: %@", self);
  for (UIView *view in self.subviews) {
    //NSLog(@"Label: %@", view.accessibilityLabel);
    if ([view.accessibilityLabel isEqualToString:accessibilityLabel]) {
      return view;
    } else {
      UIView *found = [view _viewByName:accessibilityLabel];
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

@end
