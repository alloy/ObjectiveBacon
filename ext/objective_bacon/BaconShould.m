#import "BaconShould.h"

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

- (BaconShould *)be {
  [descriptionBuffer appendString:@" be"];
  return self;
}

- (BaconShould *)a {
  [descriptionBuffer appendString:@" a"];
  return self;
}

- (BaconShould *)an {
  [descriptionBuffer appendString:@" an"];
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
    // NSLog(@"ASSERTION PASSED!");
    if (negated) {
      @throw [BaconError errorWithDescription:desc];
    }
  } else {
    // NSLog(@"ASSERTION FAILED!");
    if (!negated) {
      // NSLog(@"THROW!");
      @throw [BaconError errorWithDescription:desc];
    }
  }
}

- (void)equal:(id)otherValue {
  [self satisfy:[NSString stringWithFormat:@"equal `%@'", otherValue] block:^(id value) {
    return [object isEqualTo:otherValue];
  }];
}

- (id)raise {
  __block id result = nil;
  [self satisfy:@"raise any exception" block:^(id block) {
    @try {
      [self executeBlock:block];
      return NO;
    }
    @catch(id e) {
      // NSLog(@"Got exception: %@", [e name]);
      result = e;
      return YES;
    }
    return NO; // never reached?
  }];
  return result;
}

- (id)raise:(id)exception {
  __block id result = nil;
  [self satisfy:[NSString stringWithFormat:@"raise an exception of type `%@'", exception] block:^(id block) {
    @try {
      [self executeBlock:block];
      return NO;
    }
    @catch(id e) {
      // NSLog(@"Got exception: %@", [e name]);
      result = e;
      return [e isKindOfClass:exception];
    }
    return NO; // never reached?
  }];
  return result;
}

- (void)executeBlock:(id)block {
  NSLog(@"-[BaconShould executeBlock:] should be overriden by the client to call the given block in its original binding.");
}

- (BOOL)executeBlock:(id)block withObject:(id)obj {
  NSLog(@"-[BaconShould executeBlock:withObject:] should be overriden by the client to call the given block in its original binding.");
  return NO;
}

@end


@implementation BaconError

+ (BaconError *)errorWithDescription:(NSString *)description {
  return [[[self alloc] initWithName:@"BaconError" reason:description userInfo:nil] autorelease];
}

@end


@implementation NSObject (BaconShould)

- (BaconShould *)should {
  // NSLog(@"Should without block");
  return [[[BaconShould alloc] initWithObject:self] autorelease];
}

- (BaconShould *)should:(id)block {
  BaconShould *should = [[[BaconShould alloc] initWithObject:self] autorelease];
  [should satisfy:nil block:block];
  return should;
}

@end
