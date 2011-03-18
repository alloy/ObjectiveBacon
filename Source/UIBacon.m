#import "UIBacon.h"

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
- (NSArray *)viewsByClass:(Class)viewClass {
  return [[self _viewsByClass:viewClass] sortedArrayUsingComparator:^(id view1, id view2) {
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
  }];
}

@end


@implementation UIBacon

@end
