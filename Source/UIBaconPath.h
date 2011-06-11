#import "UIBacon.h"

@interface UIBaconPath : NSObject

+ (id)viewsByPath:(NSString *)path ofView:(BACON_VIEW *)view;

+ (NSArray *)_collectSubviews:(NSArray *)views recursive:(BOOL)recursive;

+ (id)evalVariable:(NSString *)variable;

@end
