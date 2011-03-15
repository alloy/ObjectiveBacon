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

- (void)equal:(id)otherValue {
  [self satisfy:[NSString stringWithFormat:@"equal `%@'", otherValue] block:^(id value) {
    return [object isEqualTo:otherValue];
  }];
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
  if ([exception isKindOfClass:[NSException class]]) {
    //NSLog(@"Raised exception is a NSException.");
    exceptionName = [exception name];
  } else {
    //NSLog(@"Raised exception is not a NSException, retreiving name.");
    if ([exception respondsToSelector:@selector(name)]) {
      //NSLog(@"The exception object responds to `name', so try to retreive it that way.");
      exceptionName = [exception performSelector:@selector(name)];
    }
    //else {
      //exceptionName = [self getExceptionName:exception];
    //}
  }

  [self satisfy:[NSString stringWithFormat:@"raise an exception with name `%@'", exceptionName] block:^(id block) {
    @try {
      [self executeBlock:block];
      return NO;
    }
    @catch(NSException *e) {
      //NSLog(@"Got exception: %@, expected: %@", [e name], exceptionName);
      result = [self convertException:e];
      return [[e name] isEqualToString:exceptionName];
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
    return [NSString stringWithFormat:@"%@ with %@", methodName, [arguments componentsJoinedByString:@", "]];
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


// TODO check if we do need this after all, for now we just check if the `exception' given to raise: responds to `name'.
//- (NSString *)getExceptionName:(id)exception {
  //NSLog(@"-[BaconShould getExceptionName:] should be overriden by the client to retreive the name of the exception.");
  //return @"";
//}

// Should be overriden by the client to convert the exception to the exception expected for that client's language.
- (id)convertException:(id)exception {
  return exception;
}

- (void)executeBlock:(id)block {
  NSLog(@"-[BaconShould executeBlock:] should be overriden by the client to call the given block in its original binding.");
}

- (BOOL)executeAssertionBlock:(id)block {
  @throw [NSException exceptionWithName:@"UnimplementedError"
                               reason:@"The -[BaconShould executeAssertionBlock:] should be implemented by the client. It should yield the `object' and return a boolean."
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
