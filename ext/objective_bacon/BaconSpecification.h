#import <Foundation/Foundation.h>

@class BaconContext;

@interface BaconSpecification : NSObject {
  BaconContext *context;
  NSString *description;
  id specBlock;
  NSArray *beforeFilters, *afterFilters;
  BOOL report;
  BOOL exceptionOccurred;
  NSUInteger scheduledBlocksCount;
  BOOL ranSpecBlock;
  BOOL ranAfterFilters;
}

@property (nonatomic, assign) BaconContext *context;
@property (nonatomic, retain) NSString *description;
@property (nonatomic, retain) id specBlock;
@property (nonatomic, retain) NSArray *beforeFilters, *afterFilters;
@property (nonatomic, assign) BOOL report;

- (id)initWithContext:(BaconContext *)theContext
          description:(NSString *)theDescription
                block:(id)theSpecBlock
               before:(NSArray *)theBeforeFilters
                after:(NSArray *)theAfterFilters
               report:(BOOL)shouldReport;

- (BOOL)isPostponed;

- (void)run;
- (void)runSpecBlock;
- (void)runBeforeFilters;

- (void)finishSpec;
- (void)exitSpec;

- (void)executeBlock:(void (^)())block;

@end
