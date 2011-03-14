#import <Foundation/Foundation.h>

// This is just so MacRuby will load the bundle.
void Init_objective_bacon() {};

@interface BaconContext : NSObject {
  NSString *name;
  NSMutableArray *specifications, *before, *after;
}

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSMutableArray *specifications, *before, *after;

@end

@interface BaconSpecification : NSObject {
  BaconContext *context;
  NSString *description;
  id block;
  NSArray *before, *after;
  BOOL report;
}

@property (nonatomic, assign) BaconContext *context;
@property (nonatomic, retain) NSString *description;
@property (nonatomic, retain) id block;
@property (nonatomic, retain) NSArray *before, *after;
@property (nonatomic, assign) BOOL report;

- (id)initWithContext:(BaconContext *)theContext
          description:(NSString *)theDescription
                block:(id)theBlock
               before:(NSArray *)beforeFilters
                after:(NSArray *)afterFilters
               report:(BOOL)shouldReport;

@end

@interface Bacon : NSObject

+ (Bacon *)sharedInstance;

@end
