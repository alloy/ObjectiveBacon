#import "TargetConditionals.h"

#if TARGET_OS_IPHONE
  #import <UIKit/UIKit.h>
#else
  #import <Cocoa/Cocoa.h>
#endif

@class BaconContext;
@class BaconSpecification;
@class BaconSummary;

@interface Bacon : NSObject {
  BaconSummary *summary;
  NSMutableArray *contexts;
  NSUInteger currentContextIndex;
  BOOL raiseExceptionOnFailure;
  BOOL skipRequirementsThatRaiseExceptions;
  BOOL started;
}

@property (nonatomic, retain) BaconSummary *summary;
@property (nonatomic, retain) NSMutableArray *contexts;
@property (nonatomic, assign) NSUInteger currentContextIndex;
@property (nonatomic, assign) BOOL raiseExceptionOnFailure;
@property (nonatomic, assign) BOOL skipRequirementsThatRaiseExceptions;

+ (Bacon *)sharedInstance;

- (BaconSummary *)summary;

- (void)addContext:(BaconContext *)context;
- (BaconContext *)currentContext;
- (void)contextDidFinish:(BaconContext *)context;
- (void)run;

@end


@interface BaconSummary : NSObject {
  NSMutableString *errorLog;
  NSUInteger specifications, requirements, failures, errors, skipped;
}

@property (nonatomic, assign) NSUInteger specifications, requirements, failures, errors, skipped;

- (void)addSpecification;
- (void)addRequirement;
- (void)addFailure;
- (void)addError;
- (void)addSkipped;

- (void)addToErrorLog:(id)exception context:(NSString *)name specification:(NSString *)description type:(NSString *)type;

- (void)print;

// To be overriden by the client
- (NSString *)formatExceptionBacktrace:(id)exception;

@end


@interface BaconError : NSException

+ (BaconError *)errorWithDescription:(NSString *)description;

@end
