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
	0, 1, 0, 1, 1, 1, 2, 1, 
	4, 1, 5, 1, 6, 1, 7, 1, 
	8, 1, 9, 1, 10, 1, 11, 1, 
	12, 1, 13, 2, 2, 5, 2, 4, 
	3, 2, 7, 2, 2, 7, 5, 2, 
	12, 6, 2, 13, 6, 3, 7, 2, 
	5
};

static const short _query_path_key_offsets[] = {
	0, 0, 3, 4, 5, 6, 7, 8, 
	9, 10, 11, 12, 13, 14, 16, 19, 
	24, 28, 32, 36, 40, 44, 48, 52, 
	56, 60, 64, 68, 77, 83, 92, 99, 
	107, 113, 124, 136, 149, 154, 157, 163, 
	167, 171, 175, 179, 183, 187, 191, 195, 
	199, 203, 207, 216, 222, 231, 238, 246, 
	252, 263, 275, 288, 294, 300, 312, 320, 
	331, 345, 350, 362, 368, 376, 387, 401, 
	405, 408, 412, 414, 417, 420, 424, 429, 
	436, 438, 441, 445, 451, 455, 459, 463, 
	467, 471, 475, 479, 483, 487, 491, 495, 
	504, 510, 519, 526, 534, 540, 551, 563, 
	576, 580, 592, 600, 611, 625, 630, 633, 
	636, 640, 647, 647, 650, 653
};

static const char _query_path_trans_keys[] = {
	37, 39, 47, 95, 80, 65, 84, 72, 
	95, 69, 78, 68, 95, 37, 32, 126, 
	39, 32, 126, 37, 39, 47, 32, 126, 
	39, 95, 32, 126, 39, 80, 32, 126, 
	39, 65, 32, 126, 39, 84, 32, 126, 
	39, 72, 32, 126, 39, 95, 32, 126, 
	39, 69, 32, 126, 39, 78, 32, 126, 
	39, 68, 32, 126, 39, 95, 32, 126, 
	37, 39, 32, 126, 39, 42, 47, 32, 
	64, 65, 90, 91, 126, 37, 39, 47, 
	91, 32, 126, 39, 45, 64, 32, 47, 
	48, 57, 58, 126, 39, 32, 47, 48, 
	57, 58, 126, 39, 93, 32, 47, 48, 
	57, 58, 126, 37, 39, 47, 91, 32, 
	126, 39, 32, 64, 65, 90, 91, 96, 
	97, 122, 123, 126, 39, 61, 32, 64, 
	65, 90, 91, 96, 97, 122, 123, 126, 
	39, 102, 116, 32, 64, 65, 90, 91, 
	96, 97, 122, 123, 126, 37, 39, 47, 
	32, 126, 39, 32, 126, 37, 39, 47, 
	93, 32, 126, 39, 95, 32, 126, 39, 
	80, 32, 126, 39, 65, 32, 126, 39, 
	84, 32, 126, 39, 72, 32, 126, 39, 
	95, 32, 126, 39, 69, 32, 126, 39, 
	78, 32, 126, 39, 68, 32, 126, 39, 
	95, 32, 126, 37, 39, 32, 126, 39, 
	42, 47, 32, 64, 65, 90, 91, 126, 
	37, 39, 47, 91, 32, 126, 39, 45, 
	64, 32, 47, 48, 57, 58, 126, 39, 
	32, 47, 48, 57, 58, 126, 39, 93, 
	32, 47, 48, 57, 58, 126, 37, 39, 
	47, 91, 32, 126, 39, 32, 64, 65, 
	90, 91, 96, 97, 122, 123, 126, 39, 
	61, 32, 64, 65, 90, 91, 96, 97, 
	122, 123, 126, 39, 102, 116, 32, 64, 
	65, 90, 91, 96, 97, 122, 123, 126, 
	37, 39, 47, 93, 32, 126, 37, 39, 
	47, 91, 32, 126, 39, 93, 32, 64, 
	65, 90, 91, 96, 97, 122, 123, 126, 
	39, 42, 32, 64, 65, 90, 91, 126, 
	39, 32, 64, 65, 90, 91, 96, 97, 
	122, 123, 126, 37, 39, 47, 91, 32, 
	64, 65, 90, 92, 96, 97, 122, 123, 
	126, 37, 39, 47, 32, 126, 39, 93, 
	32, 64, 65, 90, 91, 96, 97, 122, 
	123, 126, 37, 39, 47, 91, 32, 126, 
	39, 42, 32, 64, 65, 90, 91, 126, 
	39, 32, 64, 65, 90, 91, 96, 97, 
	122, 123, 126, 37, 39, 47, 91, 32, 
	64, 65, 90, 92, 96, 97, 122, 123, 
	126, 42, 47, 65, 90, 37, 47, 91, 
	45, 64, 48, 57, 48, 57, 93, 48, 
	57, 37, 47, 91, 65, 90, 97, 122, 
	61, 65, 90, 97, 122, 39, 102, 116, 
	65, 90, 97, 122, 32, 126, 39, 32, 
	126, 39, 93, 32, 126, 37, 39, 47, 
	91, 32, 126, 39, 95, 32, 126, 39, 
	80, 32, 126, 39, 65, 32, 126, 39, 
	84, 32, 126, 39, 72, 32, 126, 39, 
	95, 32, 126, 39, 69, 32, 126, 39, 
	78, 32, 126, 39, 68, 32, 126, 39, 
	95, 32, 126, 37, 39, 32, 126, 39, 
	42, 47, 32, 64, 65, 90, 91, 126, 
	37, 39, 47, 91, 32, 126, 39, 45, 
	64, 32, 47, 48, 57, 58, 126, 39, 
	32, 47, 48, 57, 58, 126, 39, 93, 
	32, 47, 48, 57, 58, 126, 37, 39, 
	47, 91, 32, 126, 39, 32, 64, 65, 
	90, 91, 96, 97, 122, 123, 126, 39, 
	61, 32, 64, 65, 90, 91, 96, 97, 
	122, 123, 126, 39, 102, 116, 32, 64, 
	65, 90, 91, 96, 97, 122, 123, 126, 
	39, 93, 32, 126, 39, 93, 32, 64, 
	65, 90, 91, 96, 97, 122, 123, 126, 
	39, 42, 32, 64, 65, 90, 91, 126, 
	39, 32, 64, 65, 90, 91, 96, 97, 
	122, 123, 126, 37, 39, 47, 91, 32, 
	64, 65, 90, 92, 96, 97, 122, 123, 
	126, 93, 65, 90, 97, 122, 37, 47, 
	91, 42, 65, 90, 65, 90, 97, 122, 
	37, 47, 91, 65, 90, 97, 122, 39, 
	32, 126, 39, 32, 126, 39, 32, 126, 
	0
};

static const char _query_path_single_lengths[] = {
	0, 3, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 0, 1, 3, 
	2, 2, 2, 2, 2, 2, 2, 2, 
	2, 2, 2, 3, 4, 3, 1, 2, 
	4, 1, 2, 3, 3, 1, 4, 2, 
	2, 2, 2, 2, 2, 2, 2, 2, 
	2, 2, 3, 4, 3, 1, 2, 4, 
	1, 2, 3, 4, 4, 2, 2, 1, 
	4, 3, 2, 4, 2, 1, 4, 2, 
	3, 2, 0, 1, 3, 0, 1, 3, 
	0, 1, 2, 4, 2, 2, 2, 2, 
	2, 2, 2, 2, 2, 2, 2, 3, 
	4, 3, 1, 2, 4, 1, 2, 3, 
	2, 2, 2, 1, 4, 1, 3, 1, 
	0, 3, 0, 1, 1, 1
};

static const char _query_path_range_lengths[] = {
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 3, 1, 3, 3, 3, 
	1, 5, 5, 5, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 3, 1, 3, 3, 3, 1, 
	5, 5, 5, 1, 1, 5, 3, 5, 
	5, 1, 5, 1, 3, 5, 5, 1, 
	0, 1, 1, 1, 0, 2, 2, 2, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 3, 
	1, 3, 3, 3, 1, 5, 5, 5, 
	1, 5, 3, 5, 5, 2, 0, 1, 
	2, 2, 0, 1, 1, 1
};

static const short _query_path_index_offsets[] = {
	0, 0, 4, 6, 8, 10, 12, 14, 
	16, 18, 20, 22, 24, 26, 28, 31, 
	36, 40, 44, 48, 52, 56, 60, 64, 
	68, 72, 76, 80, 87, 93, 100, 105, 
	111, 117, 124, 132, 141, 146, 149, 155, 
	159, 163, 167, 171, 175, 179, 183, 187, 
	191, 195, 199, 206, 212, 219, 224, 230, 
	236, 243, 251, 260, 266, 272, 280, 286, 
	293, 303, 308, 316, 322, 328, 335, 345, 
	349, 353, 357, 359, 362, 366, 369, 373, 
	379, 381, 384, 388, 394, 398, 402, 406, 
	410, 414, 418, 422, 426, 430, 434, 438, 
	445, 451, 458, 463, 469, 475, 482, 490, 
	499, 503, 511, 517, 524, 534, 538, 542, 
	545, 548, 554, 555, 558, 561
};

static const unsigned char _query_path_indicies[] = {
	0, 2, 3, 1, 4, 1, 5, 1, 
	6, 1, 7, 1, 8, 1, 9, 1, 
	10, 1, 11, 1, 12, 1, 13, 1, 
	14, 1, 15, 1, 17, 16, 1, 18, 
	17, 19, 16, 1, 17, 20, 16, 1, 
	17, 21, 16, 1, 17, 22, 16, 1, 
	17, 23, 16, 1, 17, 24, 16, 1, 
	17, 25, 16, 1, 17, 26, 16, 1, 
	17, 27, 16, 1, 17, 28, 16, 1, 
	17, 29, 16, 1, 30, 17, 16, 1, 
	17, 31, 32, 16, 33, 16, 1, 34, 
	17, 35, 36, 16, 1, 17, 37, 39, 
	16, 38, 16, 1, 17, 16, 40, 16, 
	1, 17, 41, 16, 40, 16, 1, 18, 
	17, 19, 42, 16, 1, 17, 16, 43, 
	16, 43, 16, 1, 17, 44, 16, 45, 
	16, 45, 16, 1, 46, 48, 48, 16, 
	47, 16, 47, 16, 1, 50, 51, 52, 
	49, 1, 54, 53, 1, 55, 54, 56, 
	57, 53, 1, 54, 58, 53, 1, 54, 
	59, 53, 1, 54, 60, 53, 1, 54, 
	61, 53, 1, 54, 62, 53, 1, 54, 
	63, 53, 1, 54, 64, 53, 1, 54, 
	65, 53, 1, 54, 66, 53, 1, 54, 
	67, 53, 1, 68, 54, 53, 1, 54, 
	69, 70, 53, 71, 53, 1, 72, 54, 
	73, 74, 53, 1, 54, 75, 77, 53, 
	76, 53, 1, 54, 53, 78, 53, 1, 
	54, 79, 53, 78, 53, 1, 55, 54, 
	56, 80, 53, 1, 54, 53, 81, 53, 
	81, 53, 1, 54, 82, 53, 83, 53, 
	83, 53, 1, 84, 86, 86, 53, 85, 
	53, 85, 53, 1, 50, 87, 52, 88, 
	49, 1, 89, 54, 90, 91, 53, 1, 
	54, 93, 53, 92, 53, 92, 53, 1, 
	54, 94, 53, 95, 53, 1, 54, 53, 
	96, 53, 96, 53, 1, 97, 54, 98, 
	99, 53, 96, 53, 96, 53, 1, 55, 
	54, 56, 53, 1, 17, 101, 16, 100, 
	16, 100, 16, 1, 102, 17, 103, 104, 
	16, 1, 17, 105, 16, 106, 16, 1, 
	17, 16, 107, 16, 107, 16, 1, 108, 
	17, 109, 110, 16, 107, 16, 107, 16, 
	1, 111, 112, 113, 1, 114, 115, 116, 
	1, 117, 119, 118, 1, 120, 1, 121, 
	120, 1, 0, 3, 122, 1, 123, 123, 
	1, 124, 125, 125, 1, 126, 128, 128, 
	127, 127, 1, 129, 1, 131, 130, 1, 
	131, 132, 130, 1, 133, 131, 134, 135, 
	130, 1, 131, 136, 130, 1, 131, 137, 
	130, 1, 131, 138, 130, 1, 131, 139, 
	130, 1, 131, 140, 130, 1, 131, 141, 
	130, 1, 131, 142, 130, 1, 131, 143, 
	130, 1, 131, 144, 130, 1, 131, 145, 
	130, 1, 146, 131, 130, 1, 131, 147, 
	148, 130, 149, 130, 1, 150, 131, 151, 
	152, 130, 1, 131, 153, 155, 130, 154, 
	130, 1, 131, 130, 156, 130, 1, 131, 
	157, 130, 156, 130, 1, 158, 131, 159, 
	160, 130, 1, 131, 130, 161, 130, 161, 
	130, 1, 131, 162, 130, 163, 130, 163, 
	130, 1, 164, 166, 166, 130, 165, 130, 
	165, 130, 1, 167, 168, 129, 1, 131, 
	170, 130, 169, 130, 169, 130, 1, 131, 
	171, 130, 172, 130, 1, 131, 130, 173, 
	130, 173, 130, 1, 174, 131, 175, 176, 
	130, 173, 130, 173, 130, 1, 178, 177, 
	177, 1, 179, 180, 181, 1, 182, 183, 
	1, 184, 184, 1, 185, 186, 187, 184, 
	184, 1, 1, 17, 16, 1, 54, 53, 
	1, 131, 130, 1, 0
};

static const char _query_path_trans_targs_wi[] = {
	2, 0, 13, 71, 3, 4, 5, 6, 
	7, 8, 9, 10, 11, 12, 114, 14, 
	14, 15, 16, 27, 17, 18, 19, 20, 
	21, 22, 23, 24, 25, 26, 115, 28, 
	68, 69, 16, 27, 29, 30, 31, 33, 
	31, 32, 29, 34, 35, 34, 36, 66, 
	66, 37, 39, 65, 50, 37, 38, 39, 
	50, 60, 40, 41, 42, 43, 44, 45, 
	46, 47, 48, 49, 116, 51, 62, 63, 
	39, 50, 52, 53, 54, 56, 54, 55, 
	52, 57, 58, 57, 59, 61, 61, 38, 
	60, 39, 50, 52, 61, 60, 51, 63, 
	64, 39, 50, 52, 66, 67, 16, 27, 
	29, 28, 69, 70, 16, 27, 29, 72, 
	111, 112, 2, 71, 73, 74, 75, 77, 
	75, 76, 73, 78, 79, 78, 80, 109, 
	109, 81, 81, 82, 83, 84, 95, 97, 
	85, 86, 87, 88, 89, 90, 91, 92, 
	93, 94, 117, 96, 106, 107, 84, 95, 
	97, 98, 99, 101, 99, 100, 84, 95, 
	97, 102, 103, 102, 104, 105, 105, 82, 
	83, 105, 83, 96, 107, 108, 84, 95, 
	97, 109, 110, 2, 71, 73, 72, 112, 
	113, 2, 71, 73
};

static const char _query_path_trans_actions_wi[] = {
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 11, 
	0, 13, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 23, 
	0, 39, 21, 21, 21, 11, 11, 0, 
	0, 17, 0, 1, 3, 0, 13, 7, 
	30, 5, 5, 33, 5, 0, 36, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 23, 0, 39, 
	21, 21, 21, 11, 11, 0, 0, 17, 
	0, 1, 3, 0, 36, 7, 30, 45, 
	5, 19, 19, 19, 0, 9, 25, 42, 
	0, 15, 15, 15, 0, 9, 19, 19, 
	19, 25, 42, 0, 15, 15, 15, 23, 
	0, 39, 21, 21, 21, 11, 11, 0, 
	0, 17, 0, 1, 3, 0, 0, 7, 
	30, 5, 0, 9, 0, 19, 19, 19, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 23, 0, 39, 21, 21, 
	21, 11, 11, 0, 0, 17, 0, 0, 
	0, 1, 3, 0, 9, 7, 30, 27, 
	5, 0, 9, 25, 42, 0, 15, 15, 
	15, 0, 9, 19, 19, 19, 25, 42, 
	0, 15, 15, 15
};

static const int query_path_start = 1;
static const int query_path_first_final = 114;
static const int query_path_error = 0;

static const int query_path_en_main = 1;

#line 22 "Source/UIBaconPath.m.rl"


@implementation UIBaconPath

+ (id)viewsByPath:(NSString *)path ofView:(UIView *)view {
  id result = view;

  NSString *_path = [path stringByAppendingString:@"%_PATH_END_%"];

  int cs, act = 0;
  char *ts = 0;
  char *te = 0;
  char *pe = 0;
  char *p = (char *)[_path UTF8String];
  char *eof = p + (char)[_path length];

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

  
#line 359 "Source/UIBaconPath.m"
	{
	cs = query_path_start;
	}

#line 364 "Source/UIBaconPath.m"
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
	_trans = _query_path_indicies[_trans];
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
#line 53 "Source/UIBaconPath.m.rl"
	{ pns = p; }
	break;
	case 1:
#line 54 "Source/UIBaconPath.m.rl"
	{ pne = p; }
	break;
	case 2:
#line 57 "Source/UIBaconPath.m.rl"
	{ type = STRING; pvs = p; }
	break;
	case 3:
#line 60 "Source/UIBaconPath.m.rl"
	{ type = BOOLEAN; pvs = p; }
	break;
	case 4:
#line 63 "Source/UIBaconPath.m.rl"
	{ type = VARIABLE; pvs = p; }
	break;
	case 5:
#line 66 "Source/UIBaconPath.m.rl"
	{ pve = p; }
	break;
	case 6:
#line 69 "Source/UIBaconPath.m.rl"
	{
      ts = p;
    }
	break;
	case 7:
#line 73 "Source/UIBaconPath.m.rl"
	{
      AUTO_FILTER();
      result = [view viewByName:current];
      // TODO
      //NSLog(@"raise if an element name is not at the start of the path!");
    }
	break;
	case 8:
#line 84 "Source/UIBaconPath.m.rl"
	{
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
	break;
	case 9:
#line 101 "Source/UIBaconPath.m.rl"
	{
      AUTO_FILTER();
      result = [result index:[current integerValue]];
    }
	break;
	case 10:
#line 106 "Source/UIBaconPath.m.rl"
	{
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
	break;
	case 11:
#line 138 "Source/UIBaconPath.m.rl"
	{
      NSArray *r;
      if ([result isKindOfClass:[UIView class]]) {
        r = [self _collectSubviews:[NSArray arrayWithObject:result] recursive:traverse];
      } else {
        r = [self _collectSubviews:[(UIBaconViewSet *)result array] recursive:traverse];
      }
      result = [[[UIBaconViewSet alloc] initWithArray:r] autorelease];
    }
	break;
	case 12:
#line 148 "Source/UIBaconPath.m.rl"
	{
      traverse = NO;
    }
	break;
	case 13:
#line 152 "Source/UIBaconPath.m.rl"
	{
      traverse = YES;
    }
	break;
#line 561 "Source/UIBaconPath.m"
		}
	}

_again:
	if ( cs == 0 )
		goto _out;
	if ( ++p != pe )
		goto _resume;
	_test_eof: {}
	_out: {}
	}
#line 180 "Source/UIBaconPath.m.rl"


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
