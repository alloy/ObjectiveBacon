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
    scheduledBlocksCount = 0;

    ranSpecBlock = NO;
    ranAfterFilters = NO;

    postponedBlock = nil;
  }
  return self;
}

- (void)dealloc {
  self.context = nil;
  self.description = nil;
  self.specBlock = nil;
  self.beforeFilters = nil;
  self.afterFilters = nil;
  [postponedBlock release];
  [super dealloc];
}

- (BOOL)isPostponed {
  return scheduledBlocksCount != 0;
}

- (void)run {
  if (report) {
    [[[Bacon sharedInstance] summary] addSpecification];
    printf("- %s", [self.description UTF8String]);
  }
  [self runBeforeFilters];
  if (![self isPostponed]) {
    [self runSpecBlock];
  }
}

- (void)runSpecBlock {
  ranSpecBlock = YES;
  [self executeBlock:^{
    [self.context evaluateBlock:self.specBlock];
  }];
  if (![self isPostponed]) {
    [self finishSpec];
  }
}

- (void)runBeforeFilters {
  [self executeBlock:^{
    for (id block in self.beforeFilters) {
      [self.context evaluateBlock:block];
    }
  }];
}

- (void)runAfterFilters {
  ranAfterFilters = YES;
  [self executeBlock:^{
    for (id block in self.afterFilters) {
      [self.context evaluateBlock:block];
    }
  }];
}

- (void)scheduleBlock:(id)block withDelay:(NSTimeInterval)seconds {
  // If an exception occurred, we definitely don't need to schedule any more blocks
  if (!exceptionOccurred) {
    NSLog(@"Scheduling block!");
    scheduledBlocksCount++;
    [self performSelector:@selector(runPostponedBlock:) withObject:block afterDelay:seconds];
  }
}

- (void)postponeBlock:(id)block {
  [self postponeBlock:block withTimeout:1.0];
}

- (void)postponeBlock:(id)block withTimeout:(NSTimeInterval)timeout {
  // If an exception occurred, we definitely don't need to schedule any more blocks
  if (!exceptionOccurred) {
    if (postponedBlock != nil) {
      // TODO raise exception!
    } else {
      scheduledBlocksCount++;
      postponedBlock = [block retain];
      [self performSelector:@selector(postponedBlockTimeoutExceeded) withObject:nil afterDelay:timeout];
    }
  }
}

- (void)postponedBlockTimeoutExceeded {
  [self cancelScheduledRequests];
  // TODO don't use an exception here!
  [self executeBlock:^{
    @throw [BaconError errorWithDescription:[NSString stringWithFormat:@"timeout exceeded: %@ %@", self.context.name, self.description]];
  }];
  scheduledBlocksCount = 0;
  [self finishSpec];
}

- (void)resume {
  [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(postponedBlockTimeoutExceeded) object:nil];
  id block = postponedBlock;
  postponedBlock = nil;
  [self runPostponedBlock:block];
  [block release];
}

- (void)runPostponedBlock:(id)block {
  // If an exception occurred, we definitely don't need to execute any more blocks
  if (!exceptionOccurred) {
    [self executeBlock:^{
      [self.context evaluateBlock:block];
    }];
  }
  scheduledBlocksCount--;
  if (![self isPostponed]) {
    if (ranAfterFilters) {
      [self exitSpec];
    } else if (ranSpecBlock) {
      [self finishSpec];
    } else {
      [self runSpecBlock];
    }
  }
}

- (void)finishSpec {
  // TODO add requirements missing failure to the summary
  [self runAfterFilters];
  [self exitSpec]; // TODO unless postponed
}

- (void)exitSpec {
  [self cancelScheduledRequests];
  if (report) {
    printf("\n");
  }
  [self.context specificationDidFinish:self];
}

- (void)cancelScheduledRequests {
  [NSObject cancelPreviousPerformRequestsWithTarget:self.context];
  [NSObject cancelPreviousPerformRequestsWithTarget:self];
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
        //NSLog(@"Exception: %@, %@", [e name], [e reason]);
      }
      printf("%s", [type UTF8String]);
      [[[Bacon sharedInstance] summary] addToErrorLog:e
                                              context:self.context.name
                                        specification:self.description
                                                 type:type];
    }
  }
}

@end
