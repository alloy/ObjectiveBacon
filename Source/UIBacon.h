#import <UIKit/UIKit.h>


@interface UIBacon : NSObject {

}

@end

@interface UIView (UIBacon)

- (NSArray *)viewsByClass:(Class)viewClass;

@end

