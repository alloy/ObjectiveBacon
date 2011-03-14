#import "ObjectiveBacon.h"

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
    // TODO add to summary
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
    //NSLog(@"Exception was raised: %@", e);
    exceptionOccurred = YES;
    if (report) {
      if ([e isKindOfClass:[BaconError class]]) {
        // TODO add failure to summary
        type = @" [FAILURE]";
      } else {
        // TODO add error to summary
        type = @" [ERROR]";
        NSLog(@"Exception: %@", e);
      }
      printf("%s\n", [type UTF8String]);
      // TODO add to error log
    }
  }
  @finally {
  }
}

@end

@implementation Bacon

// singleton code

static Bacon *sharedBaconInstance = nil;

+ (Bacon *)sharedInstance {
  if (sharedBaconInstance == nil) {
    sharedBaconInstance = [[super allocWithZone:NULL] init];
  }
  return sharedBaconInstance;
}

+ (id)allocWithZone:(NSZone *)zone {
  return [[self sharedInstance] retain];
}

- (id)copyWithZone:(NSZone *)zone {
  return self;
}

- (id)retain {
  return self;
}

- (NSUInteger)retainCount {
  return NSUIntegerMax;
}

- (void)release {
  // noop
}

- (id)autorelease {
  return self;
}

// implementation

@synthesize contexts, currentContextIndex;

- (id)init {
  if ((self = [super init])) {
    self.contexts = [NSMutableArray array];
    self.currentContextIndex = 0;
  }
  return self;
}

- (void)addContext:(BaconContext *)context {
  [self.contexts addObject:context];
}

- (BaconContext *)currentContext {
  return [self.contexts objectAtIndex:currentContextIndex];
}

- (void)run {
  if ([self.contexts count] > 0) {
    [[self currentContext] performSelector:@selector(run) withObject:nil afterDelay:0];
    [[NSApplication sharedApplication] run];
  } else {
    // DONE
    [self contextDidFinish:nil];
  }
}

- (void)contextDidFinish:(BaconContext *)context {
  if (currentContextIndex + 1 < [self.contexts count]) {
    currentContextIndex++;
    [self run];
  } else {
    // DONE
    // TODO print summary
    exit(0); // TODO exit with error/failure count
  }
}

@end


@implementation BaconError

+ (BaconError *)errorWithDescription:(NSString *)description {
  return [[[self alloc] initWithName:@"BaconError" reason:description userInfo:nil] autorelease];
}

@end


@implementation BaconShould

@synthesize object;

- (id)initWithObject:(id)theObject {
  if ((self = [super init])) {
    self.object = theObject;
    negated = NO;
    descriptionBuffer = [[NSMutableString alloc] init];
  }
  return self;
}

- (void)dealloc {
  self.object = nil;
  [descriptionBuffer release];
  [super dealloc];
}

- (BaconShould *)not {
  negated = YES;
  [descriptionBuffer appendString:@" not"];
  return self;
}

- (void)satisfy:(NSString *)description block:(id)block {
  // TODO add requirement to summary
  NSString *desc = description == nil ? [NSString stringWithFormat:@"satisfy `%@'", block] : description;
  desc = [NSString stringWithFormat:@"expected `%@' to%@ %@", self.object, descriptionBuffer, desc];
  //NSLog(@"Block class: %@", [block class]);
  BOOL passed;
  if ([block isKindOfClass:NSClassFromString(@"__NSStackBlock__")]) {
    //NSLog(@"objc block!");
    passed = ((BOOL (^)(id x))block)(object);
  } else {
    //NSLog(@"not objc block!");
    passed = [self executeBlock:block withObject:object];
  }
  if (passed) {
    //NSLog(@"ASSERTION PASSED!");
    if (negated) {
      @throw [BaconError errorWithDescription:desc];
    }
  } else {
    //NSLog(@"ASSERTION FAILED!");
    if (!negated) {
      //NSLog(@"THROW!");
      @throw [BaconError errorWithDescription:desc];
    }
  }
}

- (void)equal:(id)otherValue {
  [self satisfy:[NSString stringWithFormat:@"equal `%@'", otherValue] block:^(id value) {
    return [object isEqualTo:otherValue];
  }];
}

- (id)raise:(id)exception {
  __block id result = nil;
  [self satisfy:[NSString stringWithFormat:@"raise an exception of type `%@'", exception] block:^(id block) {
    @try {
      [self executeBlock:block];
      return NO;
    }
    @catch(BaconError *e) {
      result = e;
      return [e isKindOfClass:exception];
    }
    return NO; // never reached?
  }];
  return result;
}

- (BOOL)executeBlock:(id)block {
  NSLog(@"-[BaconShould executeBlock:] should be overriden by the client to call the given block in its original binding.");
  return NO;
}

- (BOOL)executeBlock:(id)block withObject:(id)obj {
  NSLog(@"-[BaconShould executeBlock:withObject:] should be overriden by the client to call the given block in its original binding.");
  return NO;
}

@end


@implementation NSObject (Bacon)

- (BaconShould *)should {
  return [[[BaconShould alloc] initWithObject:self] autorelease];
}

- (BaconShould *)should:(id)block {
  BaconShould *should = [[[BaconShould alloc] initWithObject:self] autorelease];
  [should satisfy:nil block:block];
  return should;
}

@end
