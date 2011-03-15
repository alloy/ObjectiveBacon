#import "BaconSpecification.h"
#import "ObjectiveBacon.h"
#import "BaconContext.h"
#import "BaconShould.h"


@implementation BaconSpecification

@synthesize context, description, specBlock, beforeFilters, afterFilters, report;

- (id)initWithContext:(BaconContext *)theContext
          description:(NSString *)theDescription
                block:(id)theSpecBlock
               before:(NSArray *)theBeforeFilters
                after:(NSArray *)theAfterFilters
               report:(BOOL)shouldReport {
  if ((self = [super init])) {
    self.context = theContext;
    self.description = theDescription;
    self.specBlock = theSpecBlock;
    self.report = shouldReport;

    self.beforeFilters = [[theBeforeFilters copy] autorelease];
    self.afterFilters = [[theAfterFilters copy] autorelease];

    exceptionOccurred = NO;
  }
  return self;
}

- (void)dealloc {
  self.context = nil;
  self.description = nil;
  self.specBlock = nil;
  self.beforeFilters = nil;
  self.afterFilters = nil;
  [super dealloc];
}

- (void)run {
  if (report) {
    [[[Bacon sharedInstance] summary] addSpecification];
    printf("- %s\n", [self.description UTF8String]);
  }

  [self runBeforeFilters];
  [self runSpecBlock];

  // TODO check if postponed
  [self finishSpec];
}

- (void)runSpecBlock {
  [self executeBlock:^{
    [self.context evaluateBlock:self.specBlock];
  }];
}

- (void)runBeforeFilters {
  [self executeBlock:^{
    for (id block in self.beforeFilters) {
      [self.context evaluateBlock:block];
    }
  }];
}

- (void)runAfterFilters {
  [self executeBlock:^{
    for (id block in self.afterFilters) {
      [self.context evaluateBlock:block];
    }
  }];
}

- (void)finishSpec {
  // TODO add requirements missing failure to the summary
  [self runAfterFilters];
  [self exitSpec]; // TODO unless postponed
}

- (void)exitSpec {
  [self.context specificationDidFinish:self];
}

- (void)executeBlock:(void (^)())block {
  NSString *type = nil;
  @try {
    block();
  }
  @catch(id e) {
    // NSLog(@"Exception was raised: %@", [e name]);
    exceptionOccurred = YES;
    if (report) {
      if ([e isKindOfClass:[BaconError class]]) {
        [[[Bacon sharedInstance] summary] addFailure];
        type = @" [FAILURE]";
      } else {
        [[[Bacon sharedInstance] summary] addError];
        type = @" [ERROR]";
        NSLog(@"Exception: %@, %@", [e name], [e reason]);
      }
      printf("%s\n", [type UTF8String]);
      [[[Bacon sharedInstance] summary] addToErrorLog:e
                                              context:self.context.name
                                        specification:self.description
                                                 type:type];
    }
  }
  @finally {
  }
}

@end
