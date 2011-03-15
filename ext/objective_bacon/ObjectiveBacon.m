#import "ObjectiveBacon.h"
#import "BaconContext.h"
#import "BaconSpecification.h"


// This is just so MacRuby will load the bundle.
void Init_objective_bacon() {};


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

@synthesize summary, contexts, currentContextIndex;

- (id)init {
  if ((self = [super init])) {
    self.summary = [BaconSummary new];
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
    [[self summary] print];
    exit([[self summary] failures] + [[self summary] errors]);
  }
}

@end


@implementation BaconSummary

- (id)init {
  if ((self = [super init])) {
    errorLog = [NSMutableString new];
    counters = malloc(sizeof(NSUInteger) * 4);
    int i;
    for (i = 0; i < 4; i++) {
      counters[i] = 0;
    }
  }
  return self;
}

// Probably never reached
- (void)dealloc {
  [errorLog release];
  free(counters);
  [super dealloc];
}

- (NSUInteger)specifications {
  return counters[0];
}

- (void)addSpecification {
  counters[0]++;
}

- (NSUInteger)requirements {
  return counters[1];
}

- (void)addRequirement {
  counters[1]++;
}

- (NSUInteger)failures {
  return counters[2];
}

- (void)setFailures:(NSUInteger)failures {
  counters[2] = failures;
}

- (void)addFailure {
  counters[2]++;
}

- (NSUInteger)errors {
  return counters[3];
}

- (void)addError {
  counters[3]++;
}

- (void)addToErrorLog:(id)exception context:(NSString *)name specification:(NSString *)description type:(NSString *)type {
  [errorLog appendString:[NSString stringWithFormat:@"%@ - %@: ", name, description]];
  if ([exception respondsToSelector:@selector(reason)]) {
    [errorLog appendString:[exception reason]];
  } else {
    [errorLog appendString:[exception description]];
  }
  [errorLog appendString:type];
  [errorLog appendString:@"\n"];
  // TODO callStackSymbols for NuBacon/objc?
}

- (void)print {
  printf("\n%s\n", [errorLog UTF8String]);
  printf("%d specifications (%d requirements), %d failures, %d errors\n", (int)counters[0], (int)counters[1], (int)counters[2], (int)counters[3]);
}

@end
