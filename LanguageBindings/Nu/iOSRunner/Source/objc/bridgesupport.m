/*!
@file bridgesupport.m
@description Nu reader for Apple BridgeSupport files.
@copyright Copyright (c) 2007 Neon Design Technology, Inc.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/
#ifdef DARWIN
// #ifndef IPHONE

#import <Foundation/Foundation.h>
#import <dlfcn.h>
#import "bridgesupport.h"
#import "extensions.h"
#import "symbol.h"

static NSString *getTypeStringFromAttrs(NSDictionary *attrs)
{
	static BOOL use64BitTypes = (sizeof(void *) == 8);
    if (use64BitTypes ) {
        id type64Attribute = [attrs valueForKey:@"type64"];
        if (type64Attribute)
            return [type64Attribute stringValue];
    }
    return [[attrs valueForKey:@"type"] stringValue];
}

@interface NuBridgeSupportParser : NSObject {
  NSXMLParser *xmlParser;
  NSMutableDictionary *constants;
  NSMutableDictionary *enums;
  NSMutableDictionary *functions;

  NSString *functionName;
  NSString *returnType;
  NSMutableString *argumentTypes;
}

- (id)initWithMetadata:(NSURL *) metadataURL outputDictionary:(NSMutableDictionary *) dictionary;

@end

@implementation NuBridgeSupportParser

- (id)initWithMetadata:(NSURL *) metadataURL outputDictionary:(NSMutableDictionary *) dictionary
{
  if (self = [super init]) {
    xmlParser = [[NSXMLParser alloc] initWithContentsOfURL:metadataURL];
    xmlParser.delegate = self;

    constants = [dictionary objectForKey:@"constants"];
    if (constants == nil) {
      constants = [NSMutableDictionary dictionary];
      [dictionary setObject:constants forKey:@"constants"];
    }

    enums = [dictionary objectForKey:@"enums"];
    if (enums == nil) {
      enums = [NSMutableDictionary dictionary];
      [dictionary setObject:enums forKey:@"enums"];
    }

    functionName = nil;
    argumentTypes = nil;
    returnType = nil;

    functions = [dictionary objectForKey:@"functions"];
    if (functions == nil) {
      functions = [NSMutableDictionary dictionary];
      [dictionary setObject:functions forKey:@"functions"];
    }
  }
  return self;
}

- (void)dealloc
{
  [xmlParser release];
  [functionName release];
  [returnType release];
  [argumentTypes release];
  [super dealloc];
}

- (void)start
{
  [xmlParser parse];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)name namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attrs
{
  NSLog(@"Elm: %@, namespace: %@, qualifiedName: %@ attrs: %@", name, namespaceURI, qualifiedName, attrs);

  if ([name isEqualToString:@"constant"]) {
    [constants setObject:getTypeStringFromAttrs(attrs) forKey:[[attrs valueForKey:@"name"] stringValue]];
  }
  else if ([name isEqualToString:@"enum"]) {
    [enums setObject:[NSNumber numberWithInt:[[[attrs valueForKey:@"value"] stringValue] intValue]] forKey:[[attrs valueForKey:@"name"] stringValue]];
  }
  else if ([name isEqualToString:@"function"]) {
    functionName = [[[attrs valueForKey:@"name"] stringValue] retain];
    argumentTypes = [NSMutableString new];
    returnType = @"v";
  }
  else if (functionName && [name isEqualToString:@"arg"]) {
    [argumentTypes appendString:getTypeStringFromAttrs(attrs)];
  }
  else if (functionName && [name isEqualToString:@"retval"]) {
    returnType = [getTypeStringFromAttrs(attrs) retain];
  }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)name namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
  NSLog(@"END: %@", name);
  if ([name isEqual:@"function"]) {
    NSString *signature = [NSString stringWithFormat:@"%@%@", returnType, argumentTypes];
    [functions setObject:signature forKey:functionName];
    NSLog(@"Functions: %@", functions);
    [functionName release];
    [returnType release];
    [argumentTypes release];
    functionName = nil;
    argumentTypes = nil;
    returnType = nil;
  }
}

@end


static NSString *getTypeStringFromNode(id node)
{
	static BOOL use64BitTypes = (sizeof(void *) == 8);
    if (use64BitTypes ) {
        id type64Attribute = [node attributeForName:@"type64"];
        if (type64Attribute)
            return [type64Attribute stringValue];
    }
    return [[node attributeForName:@"type"] stringValue];
}


@implementation NuBridgeSupport

+ (void)importLibrary:(NSString *) libraryPath
{
    //NSLog(@"importing library %@", libraryPath);
    dlopen([libraryPath cStringUsingEncoding:NSUTF8StringEncoding], RTLD_LAZY | RTLD_GLOBAL);
}

+ (void)importMetadata:(NSURL *) metadataURL intoDictionary:(NSMutableDictionary *) BridgeSupport
{
  NuBridgeSupportParser *parser = [[NuBridgeSupportParser alloc] initWithMetadata:metadataURL outputDictionary:BridgeSupport];
  [parser start];
  [parser release];
}

+ (void)importFramework:(NSString *) framework fromPath:(NSString *) path intoDictionary:(NSMutableDictionary *) BridgeSupport
{
    NSMutableDictionary *frameworks = [BridgeSupport valueForKey:@"frameworks"];
    if ([frameworks valueForKey:framework])
        return;
    else
        [frameworks setValue:framework forKey:framework];

    NSString *xmlPath;                            // constants, enums, functions, and more are described in an XML file.
    NSString *dylibPath;                          // sometimes a dynamic library is included to provide implementations of inline functions.

    if (path) {
        xmlPath = [NSString stringWithFormat:@"%@/Resources/BridgeSupport/%@.bridgesupport", path, framework];
        dylibPath = [NSString stringWithFormat:@"%@/Resources/BridgeSupport/%@.dylib", path, framework];
    }
    else {
        xmlPath = [NSString stringWithFormat:@"/System/Library/Frameworks/%@.framework/Resources/BridgeSupport/%@.bridgesupport", framework, framework];
        dylibPath = [NSString stringWithFormat:@"/System/Library/Frameworks/%@.framework/Resources/BridgeSupport/%@.dylib", framework, framework];
    }

    if ([NSFileManager fileExistsNamed:dylibPath])
        [self importLibrary:dylibPath];

    NSMutableDictionary *constants = [BridgeSupport valueForKey:@"constants"];
    NSMutableDictionary *enums =     [BridgeSupport valueForKey:@"enums"];
    NSMutableDictionary *functions = [BridgeSupport valueForKey:@"functions"];

    //NSXMLDocument *xmlDocument = [[[NSXMLDocument alloc] initWithContentsOfURL:[NSURL fileURLWithPath:xmlPath] options:0 error:nil] autorelease];
    //if (xmlDocument) {
        //id node;
        //NSEnumerator *childEnumerator = [[[xmlDocument rootElement] children] objectEnumerator];
        //while ((node = [childEnumerator nextObject])) {
            //if ([[node name] isEqual:@"depends_on"]) {
                //id fileName = [[node attributeForName:@"path"] stringValue];
                //id frameworkName = [[[fileName lastPathComponent] componentsSeparatedByString:@"."] objectAtIndex:0];
                //[NuBridgeSupport importFramework:frameworkName fromPath:fileName intoDictionary:BridgeSupport];
            //}
            //else if ([[node name] isEqual:@"constant"]) {
                //[constants setValue:getTypeStringFromNode(node)
                    //forKey:[[node attributeForName:@"name"] stringValue]];
            //}
            //else if ([[node name] isEqual:@"enum"]) {
                //[enums setValue:[NSNumber numberWithInt:[[[node attributeForName:@"value"] stringValue] intValue]]
                    //forKey:[[node attributeForName:@"name"] stringValue]];
            //}
            //else if ([[node name] isEqual:@"function"]) {
                //id name = [[node attributeForName:@"name"] stringValue];
                //id argumentTypes = [NSMutableString string];
                //id returnType = @"v";
                //id child;
                //NSEnumerator *nodeChildEnumerator = [[node children] objectEnumerator];
                //while ((child = [nodeChildEnumerator nextObject])) {
                    //if ([[child name] isEqual:@"arg"]) {
                        //id typeModifier = [child attributeForName:@"type_modifier"];
                        //if (typeModifier) {
                            //[argumentTypes appendString:[typeModifier stringValue]];
                        //}
						//[argumentTypes appendString:getTypeStringFromNode(child)];
                    //}
                    //else if ([[child name] isEqual:@"retval"]) {
						//returnType = getTypeStringFromNode(child);
                    //}
                    //else {
                        //NSLog(@"unrecognized type #{[child XMLString]}");
                    //}
                //}
                //id signature = [NSString stringWithFormat:@"%@%@", returnType, argumentTypes];
                //[functions setValue:signature forKey:name];
            //}
        //}
    //}
    //else {
        //// don't complain about missing bridge support files...
        ////NSString *reason = [NSString stringWithFormat:@"unable to find BridgeSupport file for %@", framework];
        ////[[NSException exceptionWithName:@"NuBridgeSupportMissing" reason:reason userInfo:nil] raise];
    //}
}

+ (void) prune
{
    NuSymbolTable *symbolTable = [NuSymbolTable sharedSymbolTable];
    id BridgeSupport = [[symbolTable symbolWithString:@"BridgeSupport"] value];
    [[BridgeSupport objectForKey:@"frameworks"] removeAllObjects];

    id key;
    for (int i = 0; i < 3; i++) {
        id dictionary = [BridgeSupport objectForKey:(i == 0) ? @"constants" : (i == 1) ? @"enums" : @"functions"];
        id keyEnumerator = [[dictionary allKeys] objectEnumerator];
        while ((key = [keyEnumerator nextObject])) {
            if (![symbolTable lookup:[key cStringUsingEncoding:NSUTF8StringEncoding]])
                [dictionary removeObjectForKey:key];
        }
    }
}

+ (NSString *) stringValue
{
    NuSymbolTable *symbolTable = [NuSymbolTable sharedSymbolTable];
    id BridgeSupport = [[symbolTable symbolWithString:@"BridgeSupport"] value];

    id result = [NSMutableString stringWithString:@"(global BridgeSupport\n"];
    id d, keyEnumerator, key;

    [result appendString:@"        (dict\n"];
    d = [BridgeSupport objectForKey:@"constants"];
    [result appendString:@"             constants:\n"];
    [result appendString:@"             (dict"];
    keyEnumerator = [[[d allKeys] sortedArrayUsingSelector:@selector(compare:)] objectEnumerator];
    while ((key = [keyEnumerator nextObject])) {
        [result appendString:[NSString stringWithFormat:@"\n                  \"%@\" \"%@\"", key, [d objectForKey:key]]];
    }
    [result appendString:@")\n"];

    d = [BridgeSupport objectForKey:@"enums"];
    [result appendString:@"             enums:\n"];
    [result appendString:@"             (dict"];
    keyEnumerator = [[[d allKeys] sortedArrayUsingSelector:@selector(compare:)] objectEnumerator];
    while ((key = [keyEnumerator nextObject])) {
        [result appendString:[NSString stringWithFormat:@"\n                  \"%@\" %@", key, [d objectForKey:key]]];
    }
    [result appendString:@")\n"];

    d = [BridgeSupport objectForKey:@"functions"];
    [result appendString:@"             functions:\n"];
    [result appendString:@"             (dict"];
    keyEnumerator = [[[d allKeys] sortedArrayUsingSelector:@selector(compare:)] objectEnumerator];
    while ((key = [keyEnumerator nextObject])) {
        [result appendString:[NSString stringWithFormat:@"\n                  \"%@\" \"%@\"", key, [d objectForKey:key]]];
    }
    [result appendString:@")\n"];

    d = [BridgeSupport objectForKey:@"frameworks"];
    [result appendString:@"             frameworks:\n"];
    [result appendString:@"             (dict"];
    keyEnumerator = [[[d allKeys] sortedArrayUsingSelector:@selector(compare:)] objectEnumerator];
    while ((key = [keyEnumerator nextObject])) {
        [result appendString:[NSString stringWithFormat:@"\n                  \"%@\" \"%@\"", key, [d objectForKey:key]]];
    }
    [result appendString:@")))\n"];
    return result;
}

@end
// #endif
#endif
