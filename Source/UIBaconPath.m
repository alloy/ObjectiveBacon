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
	3, 1, 8, 1, 12, 1, 13, 1, 
	14, 1, 15, 1, 16, 1, 17, 1, 
	18, 1, 19, 2, 2, 4, 2, 6, 
	7, 2, 9, 10, 2, 9, 11, 3, 
	9, 5, 11
};

static const char _query_path_key_offsets[] = {
	0, 0, 2, 5, 8, 11, 15, 20, 
	24, 27, 31, 35, 39, 43, 47, 51, 
	55, 59, 67, 70, 71, 75
};

static const char _query_path_trans_keys[] = {
	32, 126, 39, 32, 126, 64, 48, 57, 
	93, 48, 57, 65, 90, 97, 122, 61, 
	65, 90, 97, 122, 102, 116, 32, 126, 
	39, 32, 126, 39, 93, 32, 126, 39, 
	97, 32, 126, 39, 108, 32, 126, 39, 
	115, 32, 126, 39, 101, 32, 126, 39, 
	93, 32, 126, 39, 114, 32, 126, 39, 
	117, 32, 126, 39, 42, 47, 91, 65, 
	90, 97, 122, 39, 32, 126, 47, 65, 
	90, 97, 122, 39, 32, 126, 0
};

static const char _query_path_single_lengths[] = {
	0, 0, 1, 1, 1, 0, 1, 2, 
	1, 2, 2, 2, 2, 2, 2, 2, 
	2, 4, 1, 1, 0, 1
};

static const char _query_path_range_lengths[] = {
	0, 1, 1, 1, 1, 2, 2, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 2, 1, 0, 2, 1
};

static const char _query_path_index_offsets[] = {
	0, 0, 2, 5, 8, 11, 14, 18, 
	22, 25, 29, 33, 37, 41, 45, 49, 
	53, 57, 64, 67, 69, 72
};

static const char _query_path_indicies[] = {
	0, 1, 3, 0, 2, 5, 4, 1, 
	6, 4, 1, 7, 7, 1, 8, 9, 
	9, 1, 11, 12, 10, 1, 14, 13, 
	2, 14, 15, 13, 2, 14, 16, 13, 
	1, 14, 17, 13, 1, 14, 18, 13, 
	1, 14, 19, 13, 1, 14, 20, 13, 
	1, 14, 21, 13, 1, 14, 18, 13, 
	1, 22, 23, 24, 26, 25, 25, 1, 
	3, 0, 27, 29, 28, 25, 25, 30, 
	14, 13, 31, 0
};

static const char _query_path_trans_targs_wi[] = {
	2, 0, 17, 18, 4, 5, 17, 6, 
	7, 6, 8, 10, 15, 8, 9, 21, 
	11, 12, 13, 14, 21, 16, 1, 17, 
	19, 20, 3, 17, 17, 17, 17, 17
};

static const char _query_path_trans_actions_wi[] = {
	0, 0, 25, 33, 0, 0, 11, 1, 
	3, 0, 5, 27, 27, 0, 7, 36, 
	0, 0, 0, 0, 39, 0, 0, 13, 
	0, 0, 0, 17, 23, 15, 19, 21
};

static const char _query_path_to_state_actions[] = {
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 30, 0, 0, 0, 0
};

static const char _query_path_from_state_actions[] = {
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 9, 0, 0, 0, 0
};

static const char _query_path_eof_trans[] = {
	0, 0, 3, 0, 0, 0, 0, 0, 
	3, 3, 0, 0, 0, 0, 0, 0, 
	0, 0, 28, 29, 31, 32
};

static const int query_path_start = 17;
static const int query_path_first_final = 17;
static const int query_path_error = 0;

static const int query_path_en_main = 17;

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
  BOOL bool_value = NO;
  NSString *current;

  UIView *v;

  
#line 144 "Source/UIBaconPath.m"
	{
	cs = query_path_start;
	ts = 0;
	te = 0;
	act = 0;
	}

#line 152 "Source/UIBaconPath.m"
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
	case 8:
#line 1 "Source/UIBaconPath.m.rl"
	{ts = p;}
	break;
#line 173 "Source/UIBaconPath.m"
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
	_trans = _query_path_indicies[_trans];
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
#line 43 "Source/UIBaconPath.m.rl"
	{ pns = p; }
	break;
	case 1:
#line 44 "Source/UIBaconPath.m.rl"
	{ pne = p; }
	break;
	case 2:
#line 47 "Source/UIBaconPath.m.rl"
	{ bool_value = NO; pvs = p + 1; }
	break;
	case 3:
#line 48 "Source/UIBaconPath.m.rl"
	{ pve = p; }
	break;
	case 4:
#line 51 "Source/UIBaconPath.m.rl"
	{ bool_value = YES; pvs = p; }
	break;
	case 5:
#line 52 "Source/UIBaconPath.m.rl"
	{ pve = p; }
	break;
	case 9:
#line 1 "Source/UIBaconPath.m.rl"
	{te = p+1;}
	break;
	case 10:
#line 69 "Source/UIBaconPath.m.rl"
	{act = 1;}
	break;
	case 11:
#line 101 "Source/UIBaconPath.m.rl"
	{act = 4;}
	break;
	case 12:
#line 92 "Source/UIBaconPath.m.rl"
	{te = p+1;{
        FILTER_TRIMMED();
        NSInteger index = [current integerValue];
        if (index + 1 > [result count]) {
          return nil;
        }
        result = [result index:index];
      }}
	break;
	case 13:
#line 131 "Source/UIBaconPath.m.rl"
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
	case 14:
#line 145 "Source/UIBaconPath.m.rl"
	{te = p+1;{
        traverse = YES;
      }}
	break;
	case 15:
#line 69 "Source/UIBaconPath.m.rl"
	{te = p;p--;{
        FILTER_TRIMMED();
        result = [view viewByName:current];
        // TODO raise if it's not at the start of the path!
      }}
	break;
	case 16:
#line 75 "Source/UIBaconPath.m.rl"
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
	case 17:
#line 101 "Source/UIBaconPath.m.rl"
	{te = p;p--;{
        FILTER(pns, pne-pns);
        NSString *name = current;
        FILTER(pvs, pve-pvs);
        id value = current;

        if (bool_value) {
          value = [NSNumber numberWithBool:[value isEqualToString:@"true"]];
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
      }}
	break;
	case 18:
#line 141 "Source/UIBaconPath.m.rl"
	{te = p;p--;{
        traverse = NO;
      }}
	break;
	case 19:
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
        id value = current;

        if (bool_value) {
          value = [NSNumber numberWithBool:[value isEqualToString:@"true"]];
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
	break;
	default: break;
	}
	}
	break;
#line 417 "Source/UIBaconPath.m"
		}
	}

_again:
	_acts = _query_path_actions + _query_path_to_state_actions[cs];
	_nacts = (unsigned int) *_acts++;
	while ( _nacts-- > 0 ) {
		switch ( *_acts++ ) {
	case 6:
#line 1 "Source/UIBaconPath.m.rl"
	{ts = 0;}
	break;
	case 7:
#line 1 "Source/UIBaconPath.m.rl"
	{act = 0;}
	break;
#line 434 "Source/UIBaconPath.m"
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
#line 152 "Source/UIBaconPath.m.rl"


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
