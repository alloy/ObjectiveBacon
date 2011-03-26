#import "UIBaconPath.h"
#import "UIBacon.h"


#define FILTER(from, length) do { \
  char filter[length+1]; \
  sprintf(filter, "%.*s", length, from); \
  current = [NSString stringWithUTF8String:filter]; \
} while (0)

#define FILTER_TRIMMED() FILTER(ts+1, te-ts-2)
#define AUTO_FILTER() FILTER(ts, te-ts)

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

  int cs, act = 0;
  char *ts = 0;
  char *te = 0;
  char *pe = 0;
  char *p = (char *)[path UTF8String];
  char *eof = p + (char)[path length];

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

    # property value alpha start
    action pvas { type = VARIABLE; pvs = p; }

    # property value end
    action pve { pve = p; }

    delimiter = "/";
    one_down  = delimiter;
    any_depth = delimiter delimiter;
    quote     = "'";
    name      = quote print+ quote;
    class     = alpha+;
    index     = "[" "-"* digit+ "]";
    wildcard  = "*";

    property_name         = "[@" (alpha+ >pns %pne) "=";
    property_alpha_value  = (alpha+ >pvas %pve) "]"; # this matches constants etc
    property_string_value = "'" (print+ >pvs %pve) "']"; # this matches the value as a string
    property_bool_value   = (("true" | "false") >pvbs %pve) "]";
    property              = property_name (property_alpha_value | property_string_value | property_bool_value);

    main := |*
      name => {
        FILTER_TRIMMED();
        result = [view viewByName:current];
        // TODO
        //NSLog(@"raise if an element name is not at the start of the path!");
      };

      class => {
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
      };

      index => {
        FILTER_TRIMMED();
        result = [result index:[current integerValue]];
      };

      property => {
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
      };

      wildcard => {
        NSArray *r;
        if ([result isKindOfClass:[UIView class]]) {
          r = [self _collectSubviews:[NSArray arrayWithObject:result] recursive:traverse];
        } else {
          r = [self _collectSubviews:[(UIBaconViewSet *)result array] recursive:traverse];
        }
        result = [[[UIBaconViewSet alloc] initWithArray:r] autorelease];
      };

      one_down {
        traverse = NO;
      };

      any_depth {
        traverse = YES;
      };
    *|;

    write init;
    write exec;
  }%%

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
