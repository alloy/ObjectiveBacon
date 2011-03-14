#import "ObjectiveBacon.h"

@implementation BaconContext

@synthesize name, specifications, after, before;

- (id)initWithName:(NSString *)contextName {
  if (self = [super init]) {
    [[Bacon sharedInstance] addContext:self];

    printedName = NO;
    currentSpecificationIndex = 0;

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

- (void)run {
  NSLog(@"RUN CONTEXT!");
  if ([self.specifications count] > 0) {
    BOOL report = YES; // TODO
    if (report) {
      if (!printedName) {
        printedName = YES;
        printf("\n%s\n", [self.name UTF8String]);
      }
    }

    // TODO maybe we don't need to delay performing the method here?
    [[self currentSpecification] performSelector:@selector(run) withObject:nil afterDelay:0];
  } else {
    [self finish];
  }
}

- (BaconSpecification *)currentSpecification {
  return [self.specifications objectAtIndex:currentSpecificationIndex];
}

- (void)finish {
  [[Bacon sharedInstance] contextDidFinish:self];
}

- (void)evaluateBlock:(id)block {
  NSLog(@"-[BaconContext evaluateBlock:] should be overriden by the client to evaluate the given block in the context instance.");
}

@end

@implementation BaconSpecification

@synthesize context, description, specBlock, before, after, report;

- (id)initWithContext:(BaconContext *)theContext
          description:(NSString *)theDescription
                block:(id)theSpecBlock
               before:(NSArray *)beforeFilters
                after:(NSArray *)afterFilters
               report:(BOOL)shouldReport {
  if (self = [super init]) {
    self.context = theContext;
    self.description = theDescription;
    self.specBlock = theSpecBlock;
    self.report = shouldReport;

    self.before = [[beforeFilters copy] autorelease];
    self.after = [[afterFilters copy] autorelease];
  }
  return self;
}

- (void)dealloc {
  self.context = nil;
  self.description = nil;
  self.specBlock = nil;
  self.before = nil;
  self.after = nil;
  [super dealloc];
}

- (void)run {
  if (report) {
    // TODO add to summary
    printf("- %s\n", [self.description UTF8String]);
  }

  //[self runBeforeFilters];
  [self runSpecBlock];
}

- (void)runSpecBlock {
  [self executeBlock:^{
    [self.context evaluateBlock:self.specBlock];
  }];
}

- (void)runBeforeFilters {
  [self executeBlock:^{
    for (id block in self.before) {
      [self.context evaluateBlock:block];
    }
  }];
}

- (void)executeBlock:(void (^)())block {
  block();
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
  if (self = [super init]) {
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


@implementation BaconShould

@synthesize object;

- (id)initWithObject:(id)theObject {
  if (self = [super init]) {
    self.object = theObject;
    descriptionBuffer = [[NSMutableString alloc] init];
  }
  return self;
}

- (void)dealloc {
  self.object = nil;
  [descriptionBuffer release];
  [super dealloc];
}

- (void)satisfy:(NSString *)description block:(id)block {
  // TODO add requirement to summary
  NSString *desc = description == nil ? [NSString stringWithFormat:@"satisfy `%@'", block] : description;
  desc = [NSString stringWithFormat:@"expected `%@' to%@ %@", self.object, descriptionBuffer, desc];
  BOOL passed = [self executeBlock:block];
  if (passed) {
    NSLog(@"ASSERTION PASSED!");
  } else {
    NSLog(@"ASSERTION FAILED!");
  }
}

- (BOOL)executeBlock:(id)block {
  NSLog(@"-[BaconShould executeBlock:] should be overriden by the client to call the given block in its original binding.");
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
