#import <Cocoa/Cocoa.h>

// This is just so MacRuby will load the bundle.
void Init_objective_bacon() {};

@class BaconSpecification;

@interface BaconContext : NSObject {
  NSString *name;
  NSMutableArray *specifications, *before, *after;
  BOOL printedName;
  NSUInteger currentSpecificationIndex;
}

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSMutableArray *specifications, *before, *after;

- (id)initWithName:(NSString *)contextName;
- (void)addSpecification:(NSString *)description withBlock:(id)block report:(BOOL)report;
- (void)run;
- (BaconSpecification *)currentSpecification;
- (void)finish;
- (void)evaluateBlock:(id)block;

@end

@interface BaconSpecification : NSObject {
  BaconContext *context;
  NSString *description;
  id specBlock;
  NSArray *before, *after;
  BOOL report;
}

@property (nonatomic, assign) BaconContext *context;
@property (nonatomic, retain) NSString *description;
@property (nonatomic, retain) id specBlock;
@property (nonatomic, retain) NSArray *before, *after;
@property (nonatomic, assign) BOOL report;

- (id)initWithContext:(BaconContext *)theContext
          description:(NSString *)theDescription
                block:(id)theSpecBlock
               before:(NSArray *)beforeFilters
                after:(NSArray *)afterFilters
               report:(BOOL)shouldReport;

- (void)run;
- (void)runSpecBlock;
- (void)runBeforeFilters;
- (void)executeBlock:(void (^)())block;

@end

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
