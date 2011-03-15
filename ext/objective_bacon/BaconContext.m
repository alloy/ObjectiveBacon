#import "ObjectiveBacon.h"
#import "BaconContext.h"
#import "BaconSpecification.h"

@implementation BaconContext

@synthesize name, specifications, beforeFilters, afterFilters;

- (id)initWithName:(NSString *)contextName {
  return [self initWithName:contextName beforeFilters:nil afterFilters:nil];
}

- (id)initWithName:(NSString *)contextName
     beforeFilters:(NSArray *)theBeforeFilters
      afterFilters:(NSArray *)theAfterFilters {
  if ((self = [super init])) {
    [[Bacon sharedInstance] addContext:self];

    self.beforeFilters = theBeforeFilters == nil ? [NSMutableArray new] : [theBeforeFilters mutableCopy];
    self.afterFilters = theAfterFilters == nil ? [NSMutableArray new] : [theAfterFilters mutableCopy];

    printedName = NO;
    currentSpecificationIndex = 0;

    self.name = contextName;
    self.specifications = [NSMutableArray array];
  }
  return self;
}

- (id)childContextWithName:(NSString *)childName {
  return [[[BaconContext alloc] initWithName:childName
                               beforeFilters:self.beforeFilters
                                afterFilters:self.afterFilters] autorelease];
}

- (void)addBeforeFilter:(id)block {
  [self.beforeFilters addObject:block];
}

- (void)addAfterFilter:(id)block {
  [self.afterFilters addObject:block];
}

- (void)addSpecification:(NSString *)description withBlock:(id)block report:(BOOL)report {
  BaconSpecification *spec = [[BaconSpecification alloc] initWithContext:self
                                                             description:description
                                                                   block:block
                                                                  before:self.beforeFilters
                                                                   after:self.afterFilters
                                                                  report:report];
  [self.specifications addObject:spec];
  [spec release];
}

- (void)dealloc {
  self.name = nil;
  self.specifications = nil;
  self.beforeFilters = nil;
  self.afterFilters = nil;
  [super dealloc];
}

- (void)run {
  //NSLog(@"RUN CONTEXT!");
  if ([self.specifications count] > 0) {
    BOOL report = YES; // TODO
    if (report) {
      if (!printedName) {
        printedName = YES;
        printf("\n%s\n", [self.name UTF8String]);
      }
    }
    [[self currentSpecification] performSelector:@selector(run) withObject:nil afterDelay:0];
  } else {
    [self finishContext];
  }
}

- (BaconSpecification *)currentSpecification {
  return [self.specifications objectAtIndex:currentSpecificationIndex];
}

- (void)specificationDidFinish:(BaconSpecification *)specification {
  if (currentSpecificationIndex + 1 < [self.specifications count]) {
    currentSpecificationIndex++;
    [self run];
  } else {
    [self finishContext];
  }
}

- (void)finishContext {
  //NSLog(@"Context finished!");
  [[Bacon sharedInstance] contextDidFinish:self];
}

- (void)evaluateBlock:(id)block {
  NSLog(@"-[BaconContext evaluateBlock:] should be overriden by the client to evaluate the given block in the context instance.");
}

@end
