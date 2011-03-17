#import "AppDelegate.h"
#import "main.h" // not renaming this header, so we can easily update it from upstream
#import "ObjectiveBacon.h"

@implementation AppDelegate

@synthesize window;

- (void)applicationDidFinishLaunching:(UIApplication *)application {
  id parser = [Nu parser];

  // Create a window and make it available in the Nu runtime as a global
  self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
  [self.window makeKeyAndVisible];
  [parser parseEval:@"(set $window ((UIApplication sharedApplication) keyWindow))"];

  // Load the NuBacon source before anything else
  NSString *baconPath = [[NSBundle mainBundle] pathForResource:@"bacon" ofType:@"nu"];
  //NSLog(@"Bacon path: %@", baconPath);
  assert(baconPath != NULL && "The bacon.nu file could not be found in the app's Resources.");
  NSString *baconSource = [NSString stringWithContentsOfFile:baconPath encoding:NSUTF8StringEncoding error:nil];
  [parser parseEval:baconSource];

  // Set up iOS related globals
  [parser parseEval:@"(global TARGET_OS_IPHONE t)"];
#if TARGET_IPHONE_SIMULATOR
  [parser parseEval:@"(global TARGET_IPHONE_SIMULATOR t)"];
#else
  [parser parseEval:@"(global TARGET_IPHONE_SIMULATOR nil)"];
#endif
  if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
    [parser parseEval:@"(global UIUserInterfaceIdiomPad t)"];
    [parser parseEval:@"(global UIUserInterfaceIdiomPhone nil)"];
  } else {
    [parser parseEval:@"(global UIUserInterfaceIdiomPad nil)"];
    [parser parseEval:@"(global UIUserInterfaceIdiomPhone t)"];
  }

  // Now load the specs, which are files like: FooSpec.nu or foo_spec.nu
  NSArray *files = [[NSBundle mainBundle] pathsForResourcesOfType:@"nu" inDirectory:nil];
  //NSLog([files description]);
  [files enumerateObjectsUsingBlock:^(id path, NSUInteger idx, BOOL *stop) {
    BOOL loadSpec = NO;
    if ([path hasSuffix:@"IPadSpec.nu"] || [path hasSuffix:@"_ipad_spec.nu"]) {
      if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        loadSpec = YES;
      }
    } else if ([path hasSuffix:@"IPhoneSpec.nu"] || [path hasSuffix:@"_iphone_spec.nu"]) {
      if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        loadSpec = YES;
      }
    } else if ([path hasSuffix:@"Spec.nu"] || [path hasSuffix:@"_spec.nu"]) {
      loadSpec = YES;
    }
    if (loadSpec) {
      NSString *source = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
      [parser parseEval:source];
    }
  }];

  //[parser parseEval:@"((Bacon sharedInstance) run)"];
  [[Bacon sharedInstance] run];
}

@end
