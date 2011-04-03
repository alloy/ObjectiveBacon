#import <UIKit/UIKit.h>


@interface UIBacon : NSObject

+ (UIWindow *)sharedWindow;
+ (void)setSharedWindow:(UIWindow *)window;

@end

@interface UIBaconViewSet : NSObject {
  NSArray *viewSet;
}

- (id)initWithArray:(NSArray *)array;
- (NSArray *)array;
- (NSUInteger)count;
- (BOOL)isEmpty;
- (id)index:(NSInteger)index;

- (id)_filteredList:(NSArray *)array;

@end


@interface UIView (UIBacon)

- (UIBaconViewSet *)viewsByClass:(Class)viewClass;
- (NSArray *)_viewsByClass:(Class)viewClass recursive:(BOOL)recursive;
- (UIView *)viewByName:(NSString *)accessibilityLabel;
- (id)viewsByPath:(NSString *)path;

- (void)touch;

@end

