#import <Foundation/Foundation.h>

@interface BaconShould : NSObject {
  id object;
  BOOL negated;
  NSMutableString *descriptionBuffer;
}

@property (nonatomic, assign) id object;

- (id)initWithObject:(id)theObject;
- (void)satisfy:(NSString *)description block:(id)block;

- (BaconShould *)should;

- (BaconShould *)not;
- (void)not:(id)block;
- (BaconShould *)be;
- (void)be:(id)otherValue;
- (BaconShould *)a;
- (void)a:(id)otherValue;
- (BaconShould *)an;
- (void)an:(id)otherValue;

- (void)equal:(id)otherValue;
- (void)match:(id)value;

- (id)raise;
- (id)raise:(id)exception;


- (NSString *)descriptionForMissingMethod:(NSString *)methodName arguments:(NSArray *)arguments;
- (NSString *)predicateVersionOfMissingMethod:(NSString *)methodName arguments:(NSArray *)arguments;
- (NSString *)thirdPersonVersionOfMissingMethod:(NSString *)methodName arguments:(NSArray *)arguments;

- (BOOL)checkIfEqual:(id)object toObject:(id)otherObject;
- (BOOL)isBlock:(id)object;
- (id)convertException:(id)exception;
- (void)executeBlock:(id)block;
- (BOOL)executeAssertionBlock:(id)block;

@end


@interface BaconError : NSException

+ (BaconError *)errorWithDescription:(NSString *)description;

@end


@interface NSObject (BaconShould)

- (BaconShould *)should;
- (BaconShould *)should:(id)block;

@end
