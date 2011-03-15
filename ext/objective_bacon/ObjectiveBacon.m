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
