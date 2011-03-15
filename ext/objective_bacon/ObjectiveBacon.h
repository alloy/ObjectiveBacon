#import <Cocoa/Cocoa.h>

@class BaconContext;
@class BaconSpecification;

@interface Bacon : NSObject {
  NSMutableArray *contexts;
  NSUInteger currentContextIndex;
}

@property (nonatomic, retain) NSMutableArray *contexts;
@property (nonatomic, assign) NSUInteger currentContextIndex;

+ (Bacon *)sharedInstance;

- (void)addContext:(BaconContext *)context;
- (BaconContext *)currentContext;
- (void)contextDidFinish:(BaconContext *)context;
- (void)run;

@end
