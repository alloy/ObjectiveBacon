#import "ObjectiveBacon.h"
#import "BaconContext.h"


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

@synthesize summary, contexts, currentContextIndex, raiseExceptionOnFailure, skipRequirementsThatRaiseExceptions;

- (id)init {
  if ((self = [super init])) {
    self.summary = [BaconSummary new];
    self.contexts = [NSMutableArray array];
    self.currentContextIndex = 0;
    started = NO;

    // Currently on the iOS simulator there's a bug that will not allow exceptions to be caught.
    // Hence on the simulator we default to *not* using exceptions.
#if TARGET_IPHONE_SIMULATOR
    raiseExceptionOnFailure = NO;
    skipRequirementsThatRaiseExceptions = YES;
#else
    raiseExceptionOnFailure = YES;
    skipRequirementsThatRaiseExceptions = NO;
#endif
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
    if (!started) {
      started = YES;
      if (!raiseExceptionOnFailure) {
        printf("[!] Raising exceptions on assertion failures has been disabled.\n");
      }
      if (skipRequirementsThatRaiseExceptions) {
        printf("[!] Assertions that expect exceptions to occur, or not occur, will be skipped.\n");
      }
#ifdef __MAC_OS_X_VERSION_MAX_ALLOWED
      // On iOS the runner app has already started the app.
      [[NSApplication sharedApplication] run];
#endif
    }
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

@synthesize specifications, requirements, failures, errors, skipped;

- (id)init {
  if ((self = [super init])) {
    errorLog = [NSMutableString new];
    specifications = 0;
    requirements = 0;
    failures = 0;
    errors = 0;
    skipped = 0;
  }
  return self;
}

// Probably never reached
- (void)dealloc {
  [errorLog release];
  [super dealloc];
}

- (void)addSpecification {
  specifications++;
}

- (void)addRequirement {
  requirements++;
}

- (void)addFailure {
  failures++;
}

- (void)addError {
  errors++;
}

- (void)addSkipped {
  skipped++;
}

- (void)addToErrorLog:(id)exception context:(NSString *)name specification:(NSString *)description type:(NSString *)type {
  [errorLog appendString:[NSString stringWithFormat:@"%@ - %@: ", name, description]];
  if ([exception respondsToSelector:@selector(reason)]) {
    [errorLog appendString:[exception reason]];
  } else {
    [errorLog appendString:[exception description]];
  }
  [errorLog appendString:type];
  NSString *backtrace = [self formatExceptionBacktrace:exception];
  if (backtrace) {
    [errorLog appendString:@"\n"];
    [errorLog appendString:backtrace];
  }
  [errorLog appendString:@"\n\n"];
}

- (void)print {
  printf("\n%s\n", [errorLog UTF8String]);
  if (skipped == 0) {
    printf("%d specifications (%d requirements), %d failures, %d errors\n",
      (int)specifications, (int)requirements, (int)failures, (int)errors);
  } else {
    printf("%d specifications (%d requirements) of which %d were (partially) skipped, %d failures, %d errors\n",
      (int)specifications, (int)requirements, (int)skipped, (int)failures, (int)errors);
  }
}

// TO be overriden by the client
- (NSString *)formatExceptionBacktrace:(id)exception {
  return nil;
}

@end



@implementation BaconError

+ (BaconError *)errorWithDescription:(NSString *)description {
  return [[[self alloc] initWithName:@"BaconError" reason:description userInfo:nil] autorelease];
}

@end
