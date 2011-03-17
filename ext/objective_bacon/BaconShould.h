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
- (void)closeTo:(id)otherValue;
- (void)closeTo:(id)otherValue delta:(double)delta;
- (id)raise;
- (id)raise:(id)exception;


- (NSString *)descriptionForMissingMethod:(NSString *)methodName arguments:(NSArray *)arguments;
- (NSString *)predicateVersionOfMissingMethod:(NSString *)methodName arguments:(NSArray *)arguments;
- (NSString *)thirdPersonVersionOfMissingMethod:(NSString *)methodName arguments:(NSArray *)arguments;

- (NSString *)prettyPrint:(id)theObject;
- (BOOL)isBlock:(id)object;
- (id)convertException:(id)exception;
- (void)executeBlock:(id)block;
- (BOOL)executeAssertionBlock:(id)block;

@end


@interface NSObject (BaconShould)

- (BaconShould *)should;
- (BaconShould *)should:(id)block;

@end
