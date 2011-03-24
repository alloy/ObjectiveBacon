#import "UIBaconPath.h"
#import "UIBacon.h"


#define FILTER(from, length) do { \
  char filter[length+1]; \
  sprintf(filter, "%.*s", length, from); \
  current = [NSString stringWithUTF8String:filter]; \
} while (0)

#define FILTER_TRIMMED() FILTER(ts+1, te-ts-2)
#define AUTO_FILTER() FILTER(ts, te-ts)


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

  BOOL traverse = NO;
  NSString *current;

  %%{
    delimiter = "/";
    one_down  = delimiter;
    any_depth = delimiter delimiter;
    quote     = "'";
    name      = quote print+ quote;
    class     = alpha+;
    accessor  = "[" digit+ "]";

    main := |*
      name => {
        FILTER_TRIMMED();
        current = [current stringByReplacingOccurrencesOfString:@"\\'" withString:@"'"];
        result = [view viewByName:current];
        // TODO raise if it's not at the start of the path!
      };

      class => {
        AUTO_FILTER();
        if ([result isKindOfClass:[UIView class]]) {
          result = [result _viewsByClass:NSClassFromString(current) recursive:traverse];
        } else if ([result isKindOfClass:[UIBaconViewSet class]]) {
          NSMutableArray *r = [NSMutableArray array];
          for (UIView *v in [(UIBaconViewSet *)result array]) {
            [r addObjectsFromArray:[v _viewsByClass:NSClassFromString(current) recursive:traverse]];
          }
          result = r;
        }
        if ([result count] == 0) {
          return nil;
        }
        result = [[[UIBaconViewSet alloc] initWithArray:result] autorelease];
      };

      accessor => {
        FILTER_TRIMMED();
        result = [result index:[current intValue]];
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

@end
