#import <Cocoa/Cocoa.h>

// This is just so MacRuby will load the bundle.
void Init_objective_bacon() {};

@class BaconSpecification;

@interface BaconContext : NSObject {
  NSString *name;
  NSMutableArray *specifications, *beforeFilters, *afterFilters;
  BOOL printedName;
  NSUInteger currentSpecificationIndex;
}

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSMutableArray *specifications, *beforeFilters, *afterFilters;

- (id)initWithName:(NSString *)contextName;
- (void)addBeforeFilter:(id)block;
- (void)addAfterFilter:(id)block;
- (void)addSpecification:(NSString *)description withBlock:(id)block report:(BOOL)report;
- (void)run;
- (BaconSpecification *)currentSpecification;
- (void)specificationDidFinish:(BaconSpecification *)specification;
- (void)finishContext;
- (void)evaluateBlock:(id)block;

@end

@interface BaconSpecification : NSObject {
  BaconContext *context;
  NSString *description;
  id specBlock;
  NSArray *beforeFilters, *afterFilters;
  BOOL report;
  BOOL exceptionOccurred;
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

- (void)run;
- (void)runSpecBlock;
- (void)runBeforeFilters;

- (void)finishSpec;
- (void)exitSpec;

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


@interface BaconError : NSException

+ (BaconError *)errorWithDescription:(NSString *)description;

@end


@interface BaconShould : NSObject {
  id object;
  BOOL negated;
  NSMutableString *descriptionBuffer;
}

@property (nonatomic, assign) id object;

- (id)initWithObject:(id)theObject;
- (void)satisfy:(NSString *)description block:(id)block;

- (BOOL)executeBlock:(id)block;
- (BOOL)executeBlock:(id)block withObject:(id)obj;

- (BaconShould *)not;

- (void)equal:(id)otherValue;

@end


@interface NSObject (Bacon)

- (BaconShould *)should;
- (BaconShould *)should:(id)block;

@end
