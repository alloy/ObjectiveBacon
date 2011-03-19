#import "UIBacon.h"


@implementation UIBaconViewSet

// NSArray subclass methods

- (id)initWithArray:(NSArray *)array {
  if (self = [super init]) {
    viewSet = [array retain];
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

@interface UIView (UIBaconPrivate)

- (NSArray *)_viewsByClass:(Class)viewClass;

@end

@implementation UIView (UIBaconPrivate)

// Collects the actual views.
- (NSArray *)_viewsByClass:(Class)viewClass {
  NSMutableArray *result = [NSMutableArray array];
  for (UIView *view in self.subviews) {
    if ([view isKindOfClass:viewClass]) {
      [result addObject:view];
    } else {
      [result addObjectsFromArray:[view _viewsByClass:viewClass]];
    }
  }
  return result;
}

@end

@implementation UIView (UIBacon)

// Sorts all views by their origin in the window.
- (UIBaconViewSet *)viewsByClass:(Class)viewClass {
  return [[[UIBaconViewSet alloc] initWithArray:[[self _viewsByClass:viewClass] sortedArrayUsingComparator:^(id view1, id view2) {
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
  }]] autorelease];
}

@end
