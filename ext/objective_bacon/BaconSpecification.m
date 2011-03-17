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
    numberOfRequirementsBefore = 0;
    scheduledBlocksCount = 0;
    postponedBlock = nil;
    observedObjectAndKeyPath = nil;
    ranSpecBlock = NO;
    ranAfterFilters = NO;
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
  [observedObjectAndKeyPath release];
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
  numberOfRequirementsBefore = [[[Bacon sharedInstance] summary] requirements];
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

- (void)postponeBlockUntilChange:(id)block ofObject:(id)observable withKeyPath:(NSString *)keyPath {
  [self postponeBlockUntilChange:block ofObject:observable withKeyPath:keyPath timeout:1.0];
}

- (void)postponeBlockUntilChange:(id)block ofObject:(id)observable withKeyPath:(NSString *)keyPath timeout:(NSTimeInterval)timeout {
  // If an exception occurred, we definitely don't need to schedule any more blocks
  if (!exceptionOccurred) {
    if (postponedBlock != nil) {
      // TODO raise exception!
    } else {
      scheduledBlocksCount++;
      postponedBlock = [block retain];
      observedObjectAndKeyPath = [[NSArray arrayWithObjects:observable, keyPath, nil] retain];
      [observable addObserver:self forKeyPath:keyPath options:0 context:nil];
      [self performSelector:@selector(postponedChangeBlockTimeoutExceeded) withObject:nil afterDelay:timeout];
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

- (void)postponedChangeBlockTimeoutExceeded {
  [self removeObserver];
  [self postponedBlockTimeoutExceeded];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
  [self resume];
}

- (void)resume {
  [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(postponedBlockTimeoutExceeded) object:nil];
  [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(postponedChangeBlockTimeoutExceeded) object:nil];
  [self removeObserver];
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
  if (!exceptionOccurred && [[[Bacon sharedInstance] summary] requirements] == numberOfRequirementsBefore) {
    // the specification did not contain any requirements, so it flunked
    // TODO don't use an exception here!
    [self executeBlock:^{
      @throw [BaconError errorWithDescription:[NSString stringWithFormat:@"empty specification: %@ %@", self.context.name, self.description]];
    }];
  }
  [self runAfterFilters];
  if (![self isPostponed]) {
    [self exitSpec];
  }
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

- (void)removeObserver {
  if (observedObjectAndKeyPath != nil) {
    id object = [observedObjectAndKeyPath objectAtIndex:0];
    NSString *keyPath = [observedObjectAndKeyPath objectAtIndex:1];
    [object removeObserver:self forKeyPath:keyPath];
    [observedObjectAndKeyPath release];
    observedObjectAndKeyPath = nil;
  }
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

- (void)assertionFailed:(NSString *)failureDescription {
  exceptionOccurred = YES; // TODO continue running or not? this will only prevent any more wait blocks being scheduled
  [[[Bacon sharedInstance] summary] addFailure];
  NSString *type = @" [FAILURE]";
  printf("%s", [type UTF8String]);
  [[[Bacon sharedInstance] summary] addToErrorLog:failureDescription
                                          context:self.context.name
                                    specification:self.description
                                             type:type];
}

@end
