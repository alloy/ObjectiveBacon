#import "TargetConditionals.h"

#if TARGET_OS_IPHONE

#import <UIKit/UIKit.h>
#define BACON_WINDOW UIWindow
#define BACON_VIEW UIView

#else

#import <AppKit/AppKit.h>
#define BACON_WINDOW NSWindow
#define BACON_VIEW NSView

#endif

@interface UIBacon : NSObject

+ (BACON_WINDOW *)sharedWindow;
+ (void)setSharedWindow:(BACON_WINDOW *)window;

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

@interface BACON_VIEW (UIBacon)

- (UIBaconViewSet *)viewsByClass:(Class)viewClass;
- (NSArray *)_viewsByClass:(Class)viewClass recursive:(BOOL)recursive;
- (BACON_VIEW *)viewByName:(NSString *)accessibilityLabel;
- (id)viewsByPath:(NSString *)path;
#if TARGET_OS_IPHONE
- (void)touch;
#endif

@end

