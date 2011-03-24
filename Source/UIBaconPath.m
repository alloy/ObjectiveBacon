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
	0, 1, 2, 1, 5, 1, 6, 1, 
	7, 1, 8, 1, 9, 1, 10, 2, 
	0, 1, 2, 3, 4
};

static const char _query_path_key_offsets[] = {
	0, 0, 2, 5, 7, 10, 17, 20, 
	21
};

static const char _query_path_trans_keys[] = {
	32, 126, 39, 32, 126, 48, 57, 93, 
	48, 57, 39, 47, 91, 65, 90, 97, 
	122, 39, 32, 126, 47, 65, 90, 97, 
	122, 0
};

static const char _query_path_single_lengths[] = {
	0, 0, 1, 0, 1, 3, 1, 1, 
	0
};

static const char _query_path_range_lengths[] = {
	0, 1, 1, 1, 1, 2, 1, 0, 
	2
};

static const char _query_path_index_offsets[] = {
	0, 0, 2, 5, 7, 10, 16, 19, 
	21
};

static const char _query_path_trans_targs_wi[] = {
	2, 0, 6, 2, 5, 4, 0, 5, 
	4, 0, 1, 7, 3, 8, 8, 0, 
	6, 2, 5, 5, 5, 8, 8, 5, 
	0
};

static const char _query_path_trans_actions_wi[] = {
	0, 0, 18, 0, 13, 0, 0, 3, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	18, 0, 7, 5, 11, 0, 0, 9, 
	0
};

static const char _query_path_to_state_actions[] = {
	0, 0, 0, 0, 0, 15, 0, 0, 
	0
};

static const char _query_path_from_state_actions[] = {
	0, 0, 0, 0, 0, 1, 0, 0, 
	0
};

static const char _query_path_eof_trans[] = {
	0, 0, 3, 0, 0, 0, 11, 12, 
	14
};

static const int query_path_start = 5;
static const int query_path_first_final = 5;
static const int query_path_error = 0;

static const int query_path_en_main = 5;

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

  BOOL traverse = NO;
  NSString *current;

  
#line 107 "Source/UIBaconPath.m"
	{
	cs = query_path_start;
	ts = 0;
	te = 0;
	act = 0;
	}

#line 115 "Source/UIBaconPath.m"
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
	case 2:
#line 1 "Source/UIBaconPath.m.rl"
	{ts = p;}
	break;
#line 136 "Source/UIBaconPath.m"
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
	case 3:
#line 1 "Source/UIBaconPath.m.rl"
	{te = p+1;}
	break;
	case 4:
#line 44 "Source/UIBaconPath.m.rl"
	{act = 1;}
	break;
	case 5:
#line 68 "Source/UIBaconPath.m.rl"
	{te = p+1;{
        FILTER_TRIMMED();
        NSInteger index = [current integerValue];
        if (index > ([result count] - 1)) {
          return nil;
        }
        result = [result index:index];
      }}
	break;
	case 6:
#line 81 "Source/UIBaconPath.m.rl"
	{te = p+1;{
        traverse = YES;
      }}
	break;
	case 7:
#line 44 "Source/UIBaconPath.m.rl"
	{te = p;p--;{
        FILTER_TRIMMED();
        current = [current stringByReplacingOccurrencesOfString:@"\\'" withString:@"'"];
        result = [view viewByName:current];
        // TODO raise if it's not at the start of the path!
      }}
	break;
	case 8:
#line 51 "Source/UIBaconPath.m.rl"
	{te = p;p--;{
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
      }}
	break;
	case 9:
#line 77 "Source/UIBaconPath.m.rl"
	{te = p;p--;{
        traverse = NO;
      }}
	break;
	case 10:
#line 1 "Source/UIBaconPath.m.rl"
	{	switch( act ) {
	case 0:
	{{cs = 0; goto _again;}}
	break;
	case 1:
	{{p = ((te))-1;}
        FILTER_TRIMMED();
        current = [current stringByReplacingOccurrencesOfString:@"\\'" withString:@"'"];
        result = [view viewByName:current];
        // TODO raise if it's not at the start of the path!
      }
	break;
	default: break;
	}
	}
	break;
#line 278 "Source/UIBaconPath.m"
		}
	}

_again:
	_acts = _query_path_actions + _query_path_to_state_actions[cs];
	_nacts = (unsigned int) *_acts++;
	while ( _nacts-- > 0 ) {
		switch ( *_acts++ ) {
	case 0:
#line 1 "Source/UIBaconPath.m.rl"
	{ts = 0;}
	break;
	case 1:
#line 1 "Source/UIBaconPath.m.rl"
	{act = 0;}
	break;
#line 295 "Source/UIBaconPath.m"
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
#line 88 "Source/UIBaconPath.m.rl"


  return result;
}

@end
