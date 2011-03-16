//#import <Cocoa/Cocoa.h>
#import <UIKit/UIKit.h>

@class BaconContext;
@class BaconSpecification;
@class BaconSummary;

@interface Bacon : NSObject {
  BaconSummary *summary;
  NSMutableArray *contexts;
  NSUInteger currentContextIndex;
}

@property (nonatomic, retain) BaconSummary *summary;
@property (nonatomic, retain) NSMutableArray *contexts;
@property (nonatomic, assign) NSUInteger currentContextIndex;

+ (Bacon *)sharedInstance;

- (BaconSummary *)summary;

- (void)addContext:(BaconContext *)context;
- (BaconContext *)currentContext;
- (void)contextDidFinish:(BaconContext *)context;
- (void)run;

@end


@interface BaconSummary : NSObject {
  NSMutableString *errorLog;
  NSUInteger *counters;
}

- (NSUInteger)specifications;
- (void)addSpecification;
- (NSUInteger)requirements;
- (void)addRequirement;
- (NSUInteger)failures;
- (void)setFailures:(NSUInteger)failures;
- (void)addFailure;
- (NSUInteger)errors;
- (void)addError;

- (void)addToErrorLog:(id)exception context:(NSString *)name specification:(NSString *)description type:(NSString *)type;

- (void)print;

@end
