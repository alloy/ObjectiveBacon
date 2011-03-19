#import <UIKit/UIKit.h>


@interface UIBaconViewSet : NSObject {
  NSArray *viewSet;
}

- (id)initWithArray:(NSArray *)array;
- (NSArray *)array;
- (NSUInteger)count;
- (id)index:(NSUInteger)index;

- (id)_filteredList:(NSArray *)array;

@end

@interface UIView (UIBacon)

- (UIBaconViewSet *)viewsByClass:(Class)viewClass;

@end

