#line 1 "Source/UIBaconPath.m.rl"
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

#line 21 "Source/UIBaconPath.m.rl"

#line 24 "Source/UIBaconPath.m"
static const char _query_path_actions[] = {
	0, 1, 1, 2, 2, 0, 2, 3, 
	0
};

static const char _query_path_key_offsets[] = {
	0, 0, 1, 6, 10, 14
};

static const char _query_path_trans_keys[] = {
	47, 47, 65, 90, 97, 122, 65, 90, 
	97, 122, 65, 90, 97, 122, 0
};

static const char _query_path_single_lengths[] = {
	0, 1, 1, 0, 0, 0
};

static const char _query_path_range_lengths[] = {
	0, 0, 2, 2, 2, 0
};

static const char _query_path_index_offsets[] = {
	0, 0, 2, 6, 9, 12
};

static const char _query_path_trans_targs_wi[] = {
	2, 0, 3, 4, 4, 0, 4, 4, 
	0, 4, 4, 5, 5, 0
};

static const char _query_path_trans_actions_wi[] = {
	0, 0, 0, 3, 3, 0, 6, 6, 
	0, 1, 1, 1, 0, 0
};

static const char _query_path_eof_actions[] = {
	0, 0, 0, 0, 1, 0
};

static const int query_path_start = 1;
static const int query_path_first_final = 4;
static const int query_path_error = 0;

static const int query_path_en_main = 1;

#line 22 "Source/UIBaconPath.m.rl"


@implementation UIBaconPath

+ (id)viewsByPath:(NSString *)path ofView:(UIView *)view {
  id result = view;

  int cs, act = 0;
  char *ts = 0;
  char *te = 0;
  char *pe = 0;
  char *p = (char *)[path UTF8String];
  char *eof = p + (char)[path length];

  char *tokenstart = 0;

  // property name & value start/end
  char *pns = 0;
  char *pne = 0;
  char *pvs = 0;
  char *pve = 0;
  int type = STRING;

  BOOL traverse = NO;
  NSString *current;

  UIView *v;

  
#line 101 "Source/UIBaconPath.m"
	{
	cs = query_path_start;
	}

#line 106 "Source/UIBaconPath.m"
	{
	int _klen;
	unsigned int _trans;
	const char *_acts;
	unsigned int _nacts;
	const char *_keys;

	if ( p == pe )
		goto _test_eof;
	if ( cs == 0 )
		goto _out;
_resume:
	_keys = _query_path_trans_keys + _query_path_key_offsets[cs];
	_trans = _query_path_index_offsets[cs];

	_klen = _query_path_single_lengths[cs];
	if ( _klen > 0 ) {
		const char *_lower = _keys;
		const char *_mid;
		const char *_upper = _keys + _klen - 1;
		while (1) {
			if ( _upper < _lower )
				break;

			_mid = _lower + ((_upper-_lower) >> 1);
			if ( (*p) < *_mid )
				_upper = _mid - 1;
			else if ( (*p) > *_mid )
				_lower = _mid + 1;
			else {
				_trans += (_mid - _keys);
				goto _match;
			}
		}
		_keys += _klen;
		_trans += _klen;
	}

	_klen = _query_path_range_lengths[cs];
	if ( _klen > 0 ) {
		const char *_lower = _keys;
		const char *_mid;
		const char *_upper = _keys + (_klen<<1) - 2;
		while (1) {
			if ( _upper < _lower )
				break;

			_mid = _lower + (((_upper-_lower) >> 1) & ~1);
			if ( (*p) < _mid[0] )
				_upper = _mid - 2;
			else if ( (*p) > _mid[1] )
				_lower = _mid + 2;
			else {
				_trans += ((_mid - _keys)>>1);
				goto _match;
			}
		}
		_trans += _klen;
	}

_match:
	cs = _query_path_trans_targs_wi[_trans];

	if ( _query_path_trans_actions_wi[_trans] == 0 )
		goto _again;

	_acts = _query_path_actions + _query_path_trans_actions_wi[_trans];
	_nacts = (unsigned int) *_acts++;
	while ( _nacts-- > 0 )
	{
		switch ( *_acts++ )
		{
	case 0:
#line 70 "Source/UIBaconPath.m.rl"
	{
      NSLog(@"HIERO!");
      tokenstart = p;
    }
	break;
	case 1:
#line 93 "Source/UIBaconPath.m.rl"
	{
      NSLog(@"CLASS!");
      //AUTO_FILTER();
      FILTER(tokenstart, p-tokenstart);
      NSLog(@"Class %@", current);
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
	break;
	case 2:
#line 160 "Source/UIBaconPath.m.rl"
	{
      NSLog(@"One down!");
      traverse = NO;
    }
	break;
	case 3:
#line 165 "Source/UIBaconPath.m.rl"
	{
      NSLog(@"Any depth!");
      traverse = YES;
    }
	break;
#line 222 "Source/UIBaconPath.m"
		}
	}

_again:
	if ( cs == 0 )
		goto _out;
	if ( ++p != pe )
		goto _resume;
	_test_eof: {}
	if ( p == eof )
	{
	const char *__acts = _query_path_actions + _query_path_eof_actions[cs];
	unsigned int __nacts = (unsigned int) *__acts++;
	while ( __nacts-- > 0 ) {
		switch ( *__acts++ ) {
	case 1:
#line 93 "Source/UIBaconPath.m.rl"
	{
      NSLog(@"CLASS!");
      //AUTO_FILTER();
      FILTER(tokenstart, p-tokenstart);
      NSLog(@"Class %@", current);
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
	break;
#line 260 "Source/UIBaconPath.m"
		}
	}
	}

	_out: {}
	}
#line 192 "Source/UIBaconPath.m.rl"


  //if (cs == query_path_error) {
    //NSLog(@"There was an error!");
  //}

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
