#line 1 "Source/UIBaconPath.m.rl"
#import "UIBaconPath.h"
#import "UIBacon.h"


#define FILTER(from, length) do { \
  char filter[length+1]; \
  sprintf(filter, "%.*s", length, from); \
  current = [NSString stringWithUTF8String:filter]; \
} while (0)

#define FILTER_TRIMMED() FILTER(ts+1, te-ts-2)
#define AUTO_FILTER() FILTER(ts, te-ts)


#line 16 "Source/UIBaconPath.m.rl"

#line 19 "Source/UIBaconPath.m"
static const char _query_path_actions[] = {
	0, 1, 0, 1, 1, 1, 2, 1, 
	3, 1, 6, 1, 10, 1, 11, 1, 
	12, 1, 13, 1, 14, 1, 15, 1, 
	16, 1, 17, 2, 4, 5, 2, 7, 
	8, 2, 7, 9
};

static const char _query_path_key_offsets[] = {
	0, 0, 2, 5, 8, 11, 15, 20, 
	21, 23, 26, 30, 38, 41, 42, 46
};

static const char _query_path_trans_keys[] = {
	32, 126, 39, 32, 126, 64, 48, 57, 
	93, 48, 57, 65, 90, 97, 122, 61, 
	65, 90, 97, 122, 39, 32, 126, 39, 
	32, 126, 39, 93, 32, 126, 39, 42, 
	47, 91, 65, 90, 97, 122, 39, 32, 
	126, 47, 65, 90, 97, 122, 39, 32, 
	126, 0
};

static const char _query_path_single_lengths[] = {
	0, 0, 1, 1, 1, 0, 1, 1, 
	0, 1, 2, 4, 1, 1, 0, 1
};

static const char _query_path_range_lengths[] = {
	0, 1, 1, 1, 1, 2, 2, 0, 
	1, 1, 1, 2, 1, 0, 2, 1
};

static const char _query_path_index_offsets[] = {
	0, 0, 2, 5, 8, 11, 14, 18, 
	20, 22, 25, 29, 36, 39, 41, 44
};

static const char _query_path_trans_targs_wi[] = {
	2, 0, 12, 2, 11, 5, 4, 0, 
	11, 4, 0, 6, 6, 0, 7, 6, 
	6, 0, 8, 0, 9, 0, 10, 9, 
	11, 10, 15, 9, 11, 1, 11, 13, 
	3, 14, 14, 0, 12, 2, 11, 11, 
	11, 14, 14, 11, 10, 9, 11, 0
};

static const char _query_path_trans_actions_wi[] = {
	0, 0, 30, 0, 25, 0, 0, 0, 
	11, 0, 0, 1, 1, 0, 3, 0, 
	0, 0, 0, 0, 5, 0, 7, 0, 
	25, 7, 33, 0, 25, 0, 13, 0, 
	0, 0, 0, 0, 30, 0, 17, 15, 
	23, 0, 0, 19, 7, 0, 21, 0
};

static const char _query_path_to_state_actions[] = {
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 27, 0, 0, 0, 0
};

static const char _query_path_from_state_actions[] = {
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 9, 0, 0, 0, 0
};

static const char _query_path_eof_trans[] = {
	0, 0, 3, 0, 0, 0, 0, 0, 
	0, 3, 3, 0, 21, 22, 24, 25
};

static const int query_path_start = 11;
static const int query_path_first_final = 11;
static const int query_path_error = 0;

static const int query_path_en_main = 11;

#line 17 "Source/UIBaconPath.m.rl"


@implementation UIBaconPath

+ (id)viewsByPath:(NSString *)path ofView:(UIView *)view {
  id result = view;

  int cs, act = 0;
  char *ts = 0;
  char *te = 0;
  char *pe = 0;
  char *p = (char *)[path UTF8String];
  char *eof = p + (char)[path length];

  char *pns = 0;
  char *pne = 0;
  char *pvs = 0;
  char *pve = 0;

  BOOL traverse = NO;
  NSString *current;

  UIView *v;

  
#line 123 "Source/UIBaconPath.m"
	{
	cs = query_path_start;
	ts = 0;
	te = 0;
	act = 0;
	}

#line 131 "Source/UIBaconPath.m"
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
	_acts = _query_path_actions + _query_path_from_state_actions[cs];
	_nacts = (unsigned int) *_acts++;
	while ( _nacts-- > 0 ) {
		switch ( *_acts++ ) {
	case 6:
#line 1 "Source/UIBaconPath.m.rl"
	{ts = p;}
	break;
#line 152 "Source/UIBaconPath.m"
		}
	}

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
_eof_trans:
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
#line 42 "Source/UIBaconPath.m.rl"
	{ pns = p; }
	break;
	case 1:
#line 43 "Source/UIBaconPath.m.rl"
	{ pne = p; }
	break;
	case 2:
#line 45 "Source/UIBaconPath.m.rl"
	{ pvs = p; }
	break;
	case 3:
#line 46 "Source/UIBaconPath.m.rl"
	{ pve = p; }
	break;
	case 7:
#line 1 "Source/UIBaconPath.m.rl"
	{te = p+1;}
	break;
	case 8:
#line 59 "Source/UIBaconPath.m.rl"
	{act = 1;}
	break;
	case 9:
#line 91 "Source/UIBaconPath.m.rl"
	{act = 4;}
	break;
	case 10:
#line 82 "Source/UIBaconPath.m.rl"
	{te = p+1;{
        FILTER_TRIMMED();
        NSInteger index = [current integerValue];
        if (index + 1 > [result count]) {
          return nil;
        }
        result = [result index:index];
      }}
	break;
	case 11:
#line 117 "Source/UIBaconPath.m.rl"
	{te = p+1;{
        NSArray *r;
        if ([result isKindOfClass:[UIView class]]) {
          r = [self _collectSubviews:[NSArray arrayWithObject:result] recursive:traverse];
        } else {
          r = [self _collectSubviews:[(UIBaconViewSet *)result array] recursive:traverse];
        }
        result = [[[UIBaconViewSet alloc] initWithArray:r] autorelease];
      }}
	break;
	case 12:
#line 131 "Source/UIBaconPath.m.rl"
	{te = p+1;{
        traverse = YES;
      }}
	break;
	case 13:
#line 59 "Source/UIBaconPath.m.rl"
	{te = p;p--;{
        FILTER_TRIMMED();
        result = [view viewByName:current];
        // TODO raise if it's not at the start of the path!
      }}
	break;
	case 14:
#line 65 "Source/UIBaconPath.m.rl"
	{te = p;p--;{
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
      }}
	break;
	case 15:
#line 91 "Source/UIBaconPath.m.rl"
	{te = p;p--;{
        FILTER(pns, pne-pns);
        NSString *name = current;
        FILTER(pvs, pve-pvs);
        NSString *value = current;

        if ([result isKindOfClass:[UIView class]]) {
          // only match the current view if it matches this property
          NSString *actualValue = [result valueForKey:name];
          if (![value isEqualToString:actualValue]) {
            return nil;
          }
        } else {
          // return all views in the current view set that match this property
          NSMutableArray *r = [NSMutableArray array];
          NSArray *views = [(UIBaconViewSet *)result array];
          for (v in views) {
            NSString *actualValue = [v valueForKey:name];
            if ([value isEqualToString:actualValue]) {
              [r addObject:v];
            }
          }
          result = [[[UIBaconViewSet alloc] initWithArray:r] autorelease];
        }
      }}
	break;
	case 16:
#line 127 "Source/UIBaconPath.m.rl"
	{te = p;p--;{
        traverse = NO;
      }}
	break;
	case 17:
#line 1 "Source/UIBaconPath.m.rl"
	{	switch( act ) {
	case 0:
	{{cs = 0; goto _again;}}
	break;
	case 1:
	{{p = ((te))-1;}
        FILTER_TRIMMED();
        result = [view viewByName:current];
        // TODO raise if it's not at the start of the path!
      }
	break;
	case 4:
	{{p = ((te))-1;}
        FILTER(pns, pne-pns);
        NSString *name = current;
        FILTER(pvs, pve-pvs);
        NSString *value = current;

        if ([result isKindOfClass:[UIView class]]) {
          // only match the current view if it matches this property
          NSString *actualValue = [result valueForKey:name];
          if (![value isEqualToString:actualValue]) {
            return nil;
          }
        } else {
          // return all views in the current view set that match this property
          NSMutableArray *r = [NSMutableArray array];
          NSArray *views = [(UIBaconViewSet *)result array];
          for (v in views) {
            NSString *actualValue = [v valueForKey:name];
            if ([value isEqualToString:actualValue]) {
              [r addObject:v];
            }
          }
          result = [[[UIBaconViewSet alloc] initWithArray:r] autorelease];
        }
      }
	break;
	default: break;
	}
	}
	break;
#line 379 "Source/UIBaconPath.m"
		}
	}

_again:
	_acts = _query_path_actions + _query_path_to_state_actions[cs];
	_nacts = (unsigned int) *_acts++;
	while ( _nacts-- > 0 ) {
		switch ( *_acts++ ) {
	case 4:
#line 1 "Source/UIBaconPath.m.rl"
	{ts = 0;}
	break;
	case 5:
#line 1 "Source/UIBaconPath.m.rl"
	{act = 0;}
	break;
#line 396 "Source/UIBaconPath.m"
		}
	}

	if ( cs == 0 )
		goto _out;
	if ( ++p != pe )
		goto _resume;
	_test_eof: {}
	if ( p == eof )
	{
	if ( _query_path_eof_trans[cs] > 0 ) {
		_trans = _query_path_eof_trans[cs] - 1;
		goto _eof_trans;
	}
	}

	_out: {}
	}
#line 138 "Source/UIBaconPath.m.rl"


  return result;
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
