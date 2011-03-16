#import "BaconShould.h"
#import "ObjectiveBacon.h"


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


- (void)satisfy:(NSString *)description block:(id)block {
  [[[Bacon sharedInstance] summary] addRequirement];

  NSString *desc = description == nil ? [NSString stringWithFormat:@"satisfy `%@'", [self prettyPrint:block]] : description;
  desc = [NSString stringWithFormat:@"expected `%@' to%@ %@", [self prettyPrint:self.object], descriptionBuffer, desc];
  //NSLog(@"Block class: %@", [block class]);
  BOOL passed;
  if ([block isKindOfClass:NSClassFromString(@"__NSStackBlock__")]) {
    //NSLog(@"objc block!");
    passed = ((BOOL (^)(id x))block)(object);
  } else {
    //NSLog(@"not objc block!");
    passed = [self executeAssertionBlock:block];
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

- (BaconShould *)should {
  return self;
}

- (BaconShould *)not {
  negated = YES;
  [descriptionBuffer appendString:@" not"];
  return self;
}

- (void)not:(id)block {
  negated = YES;
  [descriptionBuffer appendString:@" not"];
  [self satisfy:nil block:block];
}

- (BaconShould *)be {
  [descriptionBuffer appendString:@" be"];
  return self;
}

- (void)be:(id)otherValue {
  if ([self isBlock:otherValue]) {
    [self satisfy:[NSString stringWithFormat:@"be `%@'", [self prettyPrint:otherValue]] block:otherValue];
  } else {
    [self satisfy:[NSString stringWithFormat:@"be `%@'", [self prettyPrint:otherValue]] block:^(id value) {
      return [value isEqualTo:otherValue];
    }];
  }
}

- (BaconShould *)a {
  [descriptionBuffer appendString:@" a"];
  return self;
}

- (void)a:(id)otherValue {
  if ([self isBlock:otherValue]) {
    [self satisfy:[NSString stringWithFormat:@"a `%@'", [self prettyPrint:otherValue]] block:otherValue];
  } else {
    [self satisfy:[NSString stringWithFormat:@"a `%@'", [self prettyPrint:otherValue]] block:^(id value) {
      return [value isEqualTo:otherValue];
    }];
  }
}

- (BaconShould *)an {
  [descriptionBuffer appendString:@" an"];
  return self;
}

- (void)an:(id)otherValue {
  if ([self isBlock:otherValue]) {
    [self satisfy:[NSString stringWithFormat:@"an `%@'", [self prettyPrint:otherValue]] block:otherValue];
  } else {
    [self satisfy:[NSString stringWithFormat:@"an `%@'", [self prettyPrint:otherValue]] block:^(id value) {
      return [value isEqualTo:otherValue];
    }];
  }
}

- (void)equal:(id)otherValue {
  [self satisfy:[NSString stringWithFormat:@"equal `%@'", [self prettyPrint:otherValue]] block:^(id value) {
    return [value isEqualTo:otherValue];
  }];
}

- (void)closeTo:(id)otherValue {
  [self closeTo:otherValue delta:0.00001];
}

// TODO this should be split into a method that does the actual checks and let this one iterate if its an array
- (void)closeTo:(id)otherValue delta:(double)delta {
  if ([otherValue isKindOfClass:[NSArray class]]) {
    [self satisfy:[NSString stringWithFormat:@"close to `%@'", [self prettyPrint:otherValue]] block:^(id values) {
      if ([values isKindOfClass:[NSArray class]]) { // check that the `object' is also an array
        int length = [values count];
        if ([otherValue count] == length) { // check that both arrays have the same number of elements
          BOOL result = YES;
          double v, ov;
          for (int i = 0; i < length; i++) {
            if (![[values objectAtIndex:i] isKindOfClass:[NSNumber class]] || ![[otherValue objectAtIndex:i] isKindOfClass:[NSNumber class]]) {
              return NO; // short circuit if any of the objects isn't a NSNumber
            }
            v  = [(NSNumber *)[values objectAtIndex:i] doubleValue];
            ov = [(NSNumber *)[otherValue objectAtIndex:i] doubleValue];
            result = (BOOL)(result && ov >= (v - delta) && ov <= (v + delta));
          }
          return result;
        }
      }
      // or should we raise an ArgumentError?
      return NO;
    }];
  } else {
    [self satisfy:[NSString stringWithFormat:@"close to `%@'", [self prettyPrint:otherValue]] block:^(id value) {
      if (![value isKindOfClass:[NSNumber class]] || ![otherValue isKindOfClass:[NSNumber class]]) {
        return NO; // short circuit if any of the objects isn't a NSNumber
      }
      double v  = [value doubleValue];
      double ov = [otherValue doubleValue];
      return (BOOL)(ov >= (v - delta) && ov <= (v + delta));
    }];
  }
}

- (void)match:(id)value {
  @throw [NSException exceptionWithName:@"ArgumentError"
                                 reason:@"ObjectiveBacon does not provide its own regexp engine. The -[BaconShould match:] method should be overriden by the client."
                             userInfo:nil];
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
      result = [self convertException:e];
      return YES;
    }
    return NO; // never reached?
  }];
  return result;
}

- (id)raise:(id)exception {
  __block id result = nil;
  NSString *exceptionName = nil;
  if ([exception isKindOfClass:[NSString class]]) {
    //NSLog(@"Expected exception object is a string");
    exceptionName = exception;
  } else if ([exception isKindOfClass:[NSException class]]) {
    //NSLog(@"Expected exception object is a NSException");
    exceptionName = [exception name];
  } else if ([exception respondsToSelector:@selector(name)]) {
    //NSLog(@"The Expected exception object responds to `name', so try to retreive it that way.");
    exceptionName = [exception performSelector:@selector(name)];
  } else {
    @throw [NSException exceptionWithName:@"ArgumentError"
                                   reason:[NSString stringWithFormat:@"Unable to figure out the name of the expected exception from object `%@'", exception]
                                 userInfo:nil];

  }
  //NSLog(@"Expected exception name: %@", exceptionName);

  [self satisfy:[NSString stringWithFormat:@"raise an exception with name `%@'", exceptionName] block:^(id block) {
    @try {
      [self executeBlock:block];
      return NO;
    }
    @catch(NSException *e) {
      //NSLog(@"Got exception: %@, expected: %@", [e name], exceptionName);
      result = [self convertException:e];
      if ([[e name] isEqualToString:exceptionName]) {
        return YES;
      } else {
        @throw e;
      }
    }
    return NO; // never reached?
  }];
  return result;
}


// Helper methods that should be used by the client when dynamically handling missing methods


- (NSString *)descriptionForMissingMethod:(NSString *)methodName arguments:(NSArray *)arguments {
  if ([arguments count] == 0) {
    return methodName;
  } else {
    NSMutableArray *formattedArgs = [NSMutableArray array];
    for (id obj in arguments) {
      [formattedArgs addObject:[self prettyPrint:obj]];
    }
    return [NSString stringWithFormat:@"%@ with %@", methodName, [formattedArgs componentsJoinedByString:@", "]];
  }
}

- (NSString *)predicateVersionOfMissingMethod:(NSString *)methodName arguments:(NSArray *)arguments {
  NSString *result = [NSString stringWithFormat:@"is%@%@",
    [[methodName substringToIndex:1] uppercaseString],
    [methodName substringFromIndex:1]
  ];
  if ([arguments count] == 0) {
    return result;
  } else if ([arguments count] == 1) {
    return [result stringByAppendingString:@":"];
  } else {
    @throw [NSException exceptionWithName:@"ArgumentError"
                                   reason:@"ObjectiveBacon does not transform selectors with multiple arguments, yet."
                                 userInfo:nil];
  }
}

- (NSString *)thirdPersonVersionOfMissingMethod:(NSString *)methodName arguments:(NSArray *)arguments {
  NSArray *parts = [methodName componentsSeparatedByCharactersInSet:[NSCharacterSet uppercaseLetterCharacterSet]];
  NSString *firstPart = [parts objectAtIndex:0];
  NSString *rest = [methodName substringFromIndex:[firstPart length]];
  NSString *result = [NSString stringWithFormat:@"%@s%@", firstPart, rest];
  if ([arguments count] == 0) {
    return result;
  } else if ([arguments count] == 1) {
    return [result stringByAppendingString:@":"];
  } else {
    @throw [NSException exceptionWithName:@"ArgumentError"
                                   reason:@"ObjectiveBacon does not transform selectors with multiple arguments, yet."
                                 userInfo:nil];
  }
}

// TODO this should be implemented when dealing with objc, but maybe it will work for Nu as well.
// For MacRuby, however, it will not, so I'm implementing this in the client.
//- (void)forwardInvocation:(NSInvocation *)invocation {
  //NSLog(@"Method missing %@", NSStringFromSelector([invocation selector]));
  //[super forwardInvocation:invocation];
//}


// Methods that should be overriden by clients

- (NSString *)prettyPrint:(id)theObject {
  return [theObject description];
}

- (BOOL)isBlock:(id)object {
  @throw [NSException exceptionWithName:@"UnimplementedError"
                               reason:@"-[BaconShould isBlock:] should be implemented by the client. It should return a boolean indicating whether or not the argument is a language block."
                             userInfo:nil];
  return NO;
}

// Should be overriden by the client to convert the exception to the exception expected for that client's language.
- (id)convertException:(id)exception {
  return exception;
}

- (void)executeBlock:(id)block {
  NSLog(@"-[BaconShould executeBlock:] should be overriden by the client to call the given block in its original binding.");
}

- (BOOL)executeAssertionBlock:(id)block {
  @throw [NSException exceptionWithName:@"UnimplementedError"
                               reason:@"-[BaconShould executeAssertionBlock:] should be implemented by the client. It should yield the `object' and return a boolean."
                             userInfo:nil];
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
