#import <Foundation/Foundation.h>

@class BaconSpecification;

@interface BaconContext : NSObject {
  NSString *name;
  NSMutableArray *specifications, *beforeFilters, *afterFilters;
  BOOL printedName;
  NSUInteger currentSpecificationIndex;

  // TODO is this the only way we can support dynamic ivars in NuBacon?
  // MacRuby is able to define ivars dynamically in any class, check if
  // it uses the objc runtime to do so.
  NSMutableDictionary *__nuivars;
}

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSMutableArray *specifications, *beforeFilters, *afterFilters;

- (id)initWithName:(NSString *)contextName;
- (id)initWithName:(NSString *)contextName
     beforeFilters:(NSArray *)theBeforeFilters
      afterFilters:(NSArray *)theAfterFilters;
- (id)childContextWithName:(NSString *)childName;

- (void)addBeforeFilter:(id)block;
- (void)addAfterFilter:(id)block;
- (void)addSpecification:(NSString *)description withBlock:(id)block report:(BOOL)report;
- (void)run;
- (BaconSpecification *)currentSpecification;
- (void)resume;
- (void)specificationDidFinish:(BaconSpecification *)specification;
- (void)finishContext;
- (void)evaluateBlock:(id)block;

@end
