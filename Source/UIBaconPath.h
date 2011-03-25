#import <UIKit/UIKit.h>

@interface UIBaconPath : NSObject

+ (id)viewsByPath:(NSString *)path ofView:(UIView *)view;
+ (NSArray *)_collectSubviews:(NSArray *)views;

@end
