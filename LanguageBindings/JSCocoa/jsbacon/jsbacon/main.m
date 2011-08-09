#import <Foundation/Foundation.h>
#import <ObjectiveBacon/ObjectiveBacon.h>
#import <ObjectiveBacon/BaconContext.h>
#import <JSCocoa/JSCocoa.h>
#import <JSCocoa/JSCocoaController.h>
#import <JavaScriptCore/JavaScriptCore.h>


// Re-raise an exception as a BaconError.
// TODO only those that were originally BaconError's should be raised
@class JSCocoaController;
@implementation JSCocoaController (JSBacon)
  BOOL customCallPathsCacheIsClean;

//
// Call a Javascript function by function reference (JSValueRef)
// 
- (JSValueRef)callJSFunction:(JSValueRef)function withArguments:(NSArray*)arguments
{
  JSObjectRef  jsFunction = JSValueToObject(ctx, function, NULL);
  // Return if function is not of function type
  if (!jsFunction)      return  NSLog(@"callJSFunction : value is not a function"), NULL;

  // Convert arguments
  JSValueRef* jsArguments = NULL;
  NSUInteger  argumentCount = [arguments count];
  if (argumentCount)
  {
    jsArguments = malloc(sizeof(JSValueRef)*argumentCount);
    for (int i=0; i<argumentCount; i++)
    {
      char typeEncoding = _C_ID;
      id argument = [arguments objectAtIndex:i];
      [JSCocoaFFIArgument toJSValueRef:&jsArguments[i] inContext:ctx typeEncoding:typeEncoding fullTypeEncoding:NULL fromStorage:&argument];
    }
  }

  if (!customCallPathsCacheIsClean)  [JSCocoa updateCustomCallPaths];

  JSValueRef exception = NULL;
  JSValueRef returnValue = JSObjectCallAsFunction(ctx, jsFunction, NULL, argumentCount, jsArguments, &exception);
  if (jsArguments) free(jsArguments);

  if (exception) 
  {
      // NSLog(@"JSException in callJSFunction : %@", [self formatJSException:exception]);
        //[self callDelegateForException:exception];
    [[BaconError errorWithDescription:[self formatJSException:exception]] raise];
    return  NULL;
  }

  return  returnValue;
}

@end


static JSCocoa *jsc = nil;


@implementation BaconContext (JSBacon)

- (void)evaluateBlock:(id)block {
  [jsc callJSFunctionNamed:@"_bacon_eval" withArguments:self, block, nil];
}

@end

int main (int argc, const char * argv[])
{
  NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];

  // Start
  jsc = [JSCocoa new];

  // This is needed because only classes created through JSCocoa can hold dynamic instance variables.
  // TODO fix the compile warning
  [JSCocoaController createClass:"JSBaconContext" parentClass:"BaconContext"];

  // 2011-08-09 23:44:29.380 jsbacon[56434:207] JSException: SyntaxError: Parse error on line 5114 of /Library/Frameworks/JSCocoa.framework/Resources/jslint-jscocoa.js
  // 2011-08-09 23:44:29.421 jsbacon[56434:207] JSException: TypeError: 'undefined' is not a function (evaluating '__jslint(lines, options)') on line 675 of /Library/Frameworks/JSCocoa.framework/Resources/class.js
  jsc.useJSLint = NO;

  // Load bacon.js
  [jsc evalJSFile:@"/Users/eloy/code/objc/ObjectiveBacon/LanguageBindings/JSCocoa/lib/bacon.js"];

  [[Bacon sharedInstance] run];

  // Never reached
  [jsc release];
  [pool drain];
  return 0;
}

