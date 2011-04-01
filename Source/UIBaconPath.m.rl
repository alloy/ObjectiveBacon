#import "UIBaconPath.h"
#import "UIBacon.h"


#define FILTER(from, length) do { \
  char filter[length+1]; \
  sprintf(filter, "%.*s", length, from); \
  current = [NSString stringWithUTF8String:filter]; \
} while (0)

#define FILTER_TRIMMED() FILTER(ts+1, p-ts-2)
#define AUTO_FILTER() FILTER(ts, p-ts)

enum {
  STRING,
  VARIABLE,
  BOOLEAN
};

%% machine query_path;
%% write data;


@implementation UIBaconPath

+ (id)viewsByPath:(NSString *)path ofView:(UIView *)view {
  id result = view;

  NSString *_path = [path stringByAppendingString:@"%_PATH_END_%"];

  int cs = 0;
  char *ts = 0;
  char *pe = 0;
  char *p = (char *)[_path UTF8String];
  char *eof = p + (char)[_path length];

  char *start = p;

  // property name & value start/end
  char *pns = 0;
  char *pne = 0;
  char *pvs = 0;
  char *pve = 0;
  int type = STRING;

  BOOL traverse = NO;
  NSString *current;

  UIView *v;

  %%{
    action pns { pns = p; }
    action pne { pne = p; }

    # property value start
    action pvs { type = STRING; pvs = p; }

    # property value bool start
    action pvbs { type = BOOLEAN; pvs = p; }

    # property variable start
    action pvvs { type = VARIABLE; pvs = p; }

    # property value end
    action pve { pve = p; }

    # token start
    action ts {
      ts = p;
    }

    action error {
      NSLog(@"A parse error occurred in: %@", path);
      return nil;
    }

    action name {
      AUTO_FILTER();
      if ([current length] == 0) {
        NSLog(@"An empty name value was encountered while parsing: %@", path);
        return nil;
      }
      result = [view viewByName:current];
      // TODO
      //NSLog(@"raise if an element name is not at the start of the path!");
    }

    action class {
      AUTO_FILTER();
      if ([result isKindOfClass:[UIView class]]) {
        result = [result _viewsByClass:NSClassFromString(current) recursive:traverse];
      } else {
        NSMutableArray *r = [NSMutableArray array];
        for (v in [(UIBaconViewSet *)result array]) {
          [r addObjectsFromArray:[v _viewsByClass:NSClassFromString(current) recursive:traverse]];
        }
        result = r;
      }
      if ([result count] == 0) {
        return nil;
      }
      result = [[[UIBaconViewSet alloc] initWithArray:result] autorelease];
    }

    action index {
      AUTO_FILTER();
      result = [result index:[current integerValue]];
    }

    action index_error {
      int location = p-start;
      printf("Index error: %d\n", location);
      printf("%s\n", start);
      for (int i = 0; i < location; i++) {
        printf(" ");
      }
      printf("^\n");
      return nil;
    }

    action property {
      FILTER(pns, pne-pns);
      NSString *name = current;
      FILTER(pvs, pve-pvs);
      id value = current;

      if (type == BOOLEAN) {
        value = [NSNumber numberWithBool:[value isEqualToString:@"true"]];
      } else if (type == VARIABLE) {
        value = [self evalVariable:value];
      }

      if ([result isKindOfClass:[UIView class]]) {
        // only match the current view if it matches this property
        NSString *actualValue = [result valueForKey:name];
        if (![value isEqual:actualValue]) {
          return nil;
        }
      } else {
        // return all views in the current view set that match this property
        NSMutableArray *r = [NSMutableArray array];
        NSArray *views = [(UIBaconViewSet *)result array];
        for (v in views) {
          NSString *actualValue = [v valueForKey:name];
          if ([value isEqual:actualValue]) {
            [r addObject:v];
          }
        }
        result = [[[UIBaconViewSet alloc] initWithArray:r] autorelease];
      }
    }

    action wildcard {
      NSArray *r;
      if ([result isKindOfClass:[UIView class]]) {
        r = [self _collectSubviews:[NSArray arrayWithObject:result] recursive:traverse];
      } else {
        r = [self _collectSubviews:[(UIBaconViewSet *)result array] recursive:traverse];
      }
      result = [[[UIBaconViewSet alloc] initWithArray:r] autorelease];
    }

    action one_down {
      traverse = NO;
    }

    action any_depth {
      traverse = YES;
    }

    # this is added to the end of each path string, so that there will always be one more final phase to transition to.
    EOP             = "%_PATH_END_%";

    one_down        = "/" %one_down;
    any_depth       = "//" %any_depth;
    delimeter       = any_depth | one_down;

    name            = "'" print* >ts %name "'";            # matches a string inside two single quotes
    class           = ([A-Z] alpha+) >ts %class;           # matches a word starting with an upcase letter as a class
    wildcard        = "*" %wildcard;                       # matches any class
    index           = "[" ("-"? digit+) >ts %index "]";    # matches an index from a view set

    prop_name       = "[@" (alpha+ >pns %pne) "=";         # matches the name of a property
    prop_var_value  = (alpha+ >pvvs %pve) "]";             # matches the value as a variable name (eg constant)
    prop_str_value  = "'" (print+ >pvs %pve) "']";         # matches the value as a string
    prop_bool_value = (("true" | "false") >pvbs %pve) "]"; # matches the value as a boolean
    property        = (prop_name (prop_var_value | prop_str_value | prop_bool_value) %property);

    #component       = (class | wildcard) ((index? property*) | (property* index?)) @!index_error;
    component       = (class | wildcard) ((index? property*) | (property* index?));

    main :=         (name? (delimeter component)* EOP) @!error;

    write init;
    write exec;
  }%%

  /*if (cs == query_path_error) {*/
    /*NSLog(@"There was an error!");*/
  /*}*/

  return result;
}

+ (id)evalVariable:(NSString *)variable {
  // TODO
  NSLog(@"raise exception that +[UIBaconPath evalVariable:] should be implemented by the client!");
  return nil;
}

+ (NSArray *)_collectSubviews:(NSArray *)views recursive:(BOOL)recursive {
  NSMutableArray *result = [NSMutableArray array];
  for (UIView *v in views) {
    NSArray *subviews = [v subviews];
    [result addObjectsFromArray:subviews];
    if (recursive) {
      [result addObjectsFromArray:[self _collectSubviews:subviews recursive:YES]];
    }
  }
  return result;
}

@end
