#import "ObjectiveBacon.h"

@implementation BaconContext

@synthesize name, specifications, after, before;

- (id)initWithName:(NSString *)contextName {
  if (self = [super init]) {
    self.name = contextName;
    self.specifications = [NSMutableArray array];
    self.before = [NSMutableArray array];
    self.after = [NSMutableArray array];
  }
  return self;
}

- (void)addSpecification:(NSString *)description withBlock:(id)block report:(BOOL)report {
  BaconSpecification *spec = [[BaconSpecification alloc] initWithContext:self
                                                             description:description
                                                                   block:block
                                                                  before:self.before
                                                                   after:self.after
                                                                  report:report];
  [self.specifications addObject:spec];
  [spec release];
}

- (void)dealloc {
  self.name = nil;
  self.specifications = nil;
  self.before = nil;
  self.after = nil;
  [super dealloc];
}

@end

@implementation BaconSpecification

@synthesize context, description, block, before, after, report;

- (id)initWithContext:(BaconContext *)theContext
          description:(NSString *)theDescription
                block:(id)theBlock
               before:(NSArray *)beforeFilters
                after:(NSArray *)afterFilters
               report:(BOOL)shouldReport {
  if (self = [super init]) {
    self.context = theContext;
    self.description = theDescription;
    self.block = theBlock;
    self.report = shouldReport;

    self.before = [[beforeFilters copy] autorelease];
    self.after = [[afterFilters copy] autorelease];
  }
  return self;
}

- (void)dealloc {
  self.context = nil;
  self.description = nil;
  self.block = nil;
  self.before = nil;
  self.after = nil;
  [super dealloc];
}

@end
