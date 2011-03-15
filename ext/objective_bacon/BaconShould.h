#import <Foundation/Foundation.h>

@interface BaconShould : NSObject {
  id object;
  BOOL negated;
  NSMutableString *descriptionBuffer;
}

@property (nonatomic, assign) id object;

- (id)initWithObject:(id)theObject;
- (void)satisfy:(NSString *)description block:(id)block;

- (BaconShould *)not;
- (BaconShould *)be;
- (BaconShould *)a;
- (BaconShould *)an;

- (void)equal:(id)otherValue;

- (id)raise;
- (id)raise:(id)exception;


- (NSString *)descriptionForMissingMethod:(NSString *)methodName arguments:(NSArray *)arguments;
- (NSString *)predicateVersionOfMissingMethod:(NSString *)methodName arguments:(NSArray *)arguments;
- (NSString *)thirdPersonVersionOfMissingMethod:(NSString *)methodName arguments:(NSArray *)arguments;

// - (NSString *)getExceptionName:(id)exception;
- (id)convertException:(id)exception;
- (void)executeBlock:(id)block;
- (BOOL)executeBlock:(id)block withObject:(id)obj;

@end


@interface BaconError : NSException

+ (BaconError *)errorWithDescription:(NSString *)description;

@end


@interface NSObject (BaconShould)

- (BaconShould *)should;
- (BaconShould *)should:(id)block;

@end
