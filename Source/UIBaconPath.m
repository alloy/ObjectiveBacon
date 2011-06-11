
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

#line 26 "Source/UIBaconPath.m"
static const char _query_path_actions[] = {
	0, 1, 0, 1, 1, 1, 2, 1, 
	4, 1, 5, 1, 6, 1, 7, 1, 
	8, 1, 9, 1, 10, 1, 11, 1, 
	12, 1, 13, 1, 14, 2, 2, 5, 
	2, 4, 3, 2, 6, 8, 2, 8, 
	2, 2, 8, 5, 2, 13, 6, 2, 
	14, 6, 3, 8, 2, 5
};

static const short _query_path_key_offsets[] = {
	0, 0, 3, 4, 5, 6, 7, 8, 
	9, 10, 11, 12, 13, 14, 17, 20, 
	25, 29, 33, 37, 41, 45, 49, 53, 
	57, 61, 65, 69, 78, 84, 93, 100, 
	108, 114, 118, 129, 141, 154, 159, 162, 
	168, 172, 176, 180, 184, 188, 192, 196, 
	200, 204, 208, 212, 221, 227, 236, 243, 
	251, 257, 261, 272, 284, 297, 303, 309, 
	321, 332, 344, 357, 363, 366, 372, 376, 
	380, 384, 388, 392, 396, 400, 404, 408, 
	412, 416, 425, 431, 440, 447, 455, 461, 
	465, 476, 488, 501, 507, 513, 522, 529, 
	537, 542, 553, 565, 578, 590, 602, 608, 
	616, 627, 641, 647, 659, 665, 674, 681, 
	689, 694, 702, 713, 727, 739, 745, 756, 
	768, 781, 786, 798, 804, 813, 820, 828, 
	836, 847, 861, 865, 868, 872, 874, 877, 
	880, 881, 885, 890, 897, 899, 902, 906, 
	912, 916, 920, 924, 928, 932, 936, 940, 
	944, 948, 952, 956, 965, 971, 980, 987, 
	995, 1001, 1005, 1016, 1028, 1041, 1045, 1057, 
	1068, 1080, 1093, 1097, 1100, 1104, 1110, 1114, 
	1118, 1122, 1126, 1130, 1134, 1138, 1142, 1146, 
	1150, 1154, 1163, 1169, 1178, 1185, 1193, 1199, 
	1203, 1214, 1226, 1239, 1243, 1255, 1261, 1272, 
	1284, 1297, 1309, 1317, 1328, 1342, 1351, 1358, 
	1366, 1371, 1375, 1387, 1393, 1402, 1409, 1417, 
	1422, 1430, 1441, 1455, 1460, 1463, 1467, 1472, 
	1479, 1481, 1486, 1489, 1493, 1495, 1498, 1500, 
	1503, 1507, 1514, 1514, 1517, 1520, 1523, 1526
};

static const char _query_path_trans_keys[] = {
	37, 39, 47, 95, 80, 65, 84, 72, 
	95, 69, 78, 68, 95, 37, 39, 32, 
	126, 39, 32, 126, 37, 39, 47, 32, 
	126, 39, 95, 32, 126, 39, 80, 32, 
	126, 39, 65, 32, 126, 39, 84, 32, 
	126, 39, 72, 32, 126, 39, 95, 32, 
	126, 39, 69, 32, 126, 39, 78, 32, 
	126, 39, 68, 32, 126, 39, 95, 32, 
	126, 37, 39, 32, 126, 39, 42, 47, 
	32, 64, 65, 90, 91, 126, 37, 39, 
	47, 91, 32, 126, 39, 45, 64, 32, 
	47, 48, 57, 58, 126, 39, 32, 47, 
	48, 57, 58, 126, 39, 93, 32, 47, 
	48, 57, 58, 126, 37, 39, 47, 91, 
	32, 126, 39, 64, 32, 126, 39, 32, 
	64, 65, 90, 91, 96, 97, 122, 123, 
	126, 39, 61, 32, 64, 65, 90, 91, 
	96, 97, 122, 123, 126, 39, 102, 116, 
	32, 64, 65, 90, 91, 96, 97, 122, 
	123, 126, 37, 39, 47, 32, 126, 39, 
	32, 126, 37, 39, 47, 93, 32, 126, 
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
	126, 39, 64, 32, 126, 39, 32, 64, 
	65, 90, 91, 96, 97, 122, 123, 126, 
	39, 61, 32, 64, 65, 90, 91, 96, 
	97, 122, 123, 126, 39, 102, 116, 32, 
	64, 65, 90, 91, 96, 97, 122, 123, 
	126, 37, 39, 47, 93, 32, 126, 37, 
	39, 47, 91, 32, 126, 39, 93, 32, 
	64, 65, 90, 91, 96, 97, 122, 123, 
	126, 39, 32, 64, 65, 90, 91, 96, 
	97, 122, 123, 126, 39, 61, 32, 64, 
	65, 90, 91, 96, 97, 122, 123, 126, 
	39, 102, 116, 32, 64, 65, 90, 91, 
	96, 97, 122, 123, 126, 37, 39, 47, 
	93, 32, 126, 39, 32, 126, 37, 39, 
	47, 93, 32, 126, 39, 95, 32, 126, 
	39, 80, 32, 126, 39, 65, 32, 126, 
	39, 84, 32, 126, 39, 72, 32, 126, 
	39, 95, 32, 126, 39, 69, 32, 126, 
	39, 78, 32, 126, 39, 68, 32, 126, 
	39, 95, 32, 126, 37, 39, 32, 126, 
	39, 42, 47, 32, 64, 65, 90, 91, 
	126, 37, 39, 47, 91, 32, 126, 39, 
	45, 64, 32, 47, 48, 57, 58, 126, 
	39, 32, 47, 48, 57, 58, 126, 39, 
	93, 32, 47, 48, 57, 58, 126, 37, 
	39, 47, 91, 32, 126, 39, 64, 32, 
	126, 39, 32, 64, 65, 90, 91, 96, 
	97, 122, 123, 126, 39, 61, 32, 64, 
	65, 90, 91, 96, 97, 122, 123, 126, 
	39, 102, 116, 32, 64, 65, 90, 91, 
	96, 97, 122, 123, 126, 37, 39, 47, 
	93, 32, 126, 37, 39, 47, 91, 32, 
	126, 39, 45, 64, 32, 47, 48, 57, 
	58, 126, 39, 32, 47, 48, 57, 58, 
	126, 39, 93, 32, 47, 48, 57, 58, 
	126, 37, 39, 47, 32, 126, 39, 32, 
	64, 65, 90, 91, 96, 97, 122, 123, 
	126, 39, 61, 32, 64, 65, 90, 91, 
	96, 97, 122, 123, 126, 39, 102, 116, 
	32, 64, 65, 90, 91, 96, 97, 122, 
	123, 126, 39, 93, 32, 64, 65, 90, 
	91, 96, 97, 122, 123, 126, 39, 93, 
	32, 64, 65, 90, 91, 96, 97, 122, 
	123, 126, 37, 39, 47, 91, 32, 126, 
	39, 42, 32, 64, 65, 90, 91, 126, 
	39, 32, 64, 65, 90, 91, 96, 97, 
	122, 123, 126, 37, 39, 47, 91, 32, 
	64, 65, 90, 92, 96, 97, 122, 123, 
	126, 37, 39, 47, 93, 32, 126, 39, 
	93, 32, 64, 65, 90, 91, 96, 97, 
	122, 123, 126, 37, 39, 47, 91, 32, 
	126, 39, 45, 64, 32, 47, 48, 57, 
	58, 126, 39, 32, 47, 48, 57, 58, 
	126, 39, 93, 32, 47, 48, 57, 58, 
	126, 37, 39, 47, 32, 126, 39, 42, 
	32, 64, 65, 90, 91, 126, 39, 32, 
	64, 65, 90, 91, 96, 97, 122, 123, 
	126, 37, 39, 47, 91, 32, 64, 65, 
	90, 92, 96, 97, 122, 123, 126, 39, 
	93, 32, 64, 65, 90, 91, 96, 97, 
	122, 123, 126, 37, 39, 47, 91, 32, 
	126, 39, 32, 64, 65, 90, 91, 96, 
	97, 122, 123, 126, 39, 61, 32, 64, 
	65, 90, 91, 96, 97, 122, 123, 126, 
	39, 102, 116, 32, 64, 65, 90, 91, 
	96, 97, 122, 123, 126, 37, 39, 47, 
	32, 126, 39, 93, 32, 64, 65, 90, 
	91, 96, 97, 122, 123, 126, 37, 39, 
	47, 91, 32, 126, 39, 45, 64, 32, 
	47, 48, 57, 58, 126, 39, 32, 47, 
	48, 57, 58, 126, 39, 93, 32, 47, 
	48, 57, 58, 126, 39, 42, 32, 64, 
	65, 90, 91, 126, 39, 32, 64, 65, 
	90, 91, 96, 97, 122, 123, 126, 37, 
	39, 47, 91, 32, 64, 65, 90, 92, 
	96, 97, 122, 123, 126, 42, 47, 65, 
	90, 37, 47, 91, 45, 64, 48, 57, 
	48, 57, 93, 48, 57, 37, 47, 91, 
	64, 65, 90, 97, 122, 61, 65, 90, 
	97, 122, 39, 102, 116, 65, 90, 97, 
	122, 32, 126, 39, 32, 126, 39, 93, 
	32, 126, 37, 39, 47, 91, 32, 126, 
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
	126, 39, 64, 32, 126, 39, 32, 64, 
	65, 90, 91, 96, 97, 122, 123, 126, 
	39, 61, 32, 64, 65, 90, 91, 96, 
	97, 122, 123, 126, 39, 102, 116, 32, 
	64, 65, 90, 91, 96, 97, 122, 123, 
	126, 39, 93, 32, 126, 39, 93, 32, 
	64, 65, 90, 91, 96, 97, 122, 123, 
	126, 39, 32, 64, 65, 90, 91, 96, 
	97, 122, 123, 126, 39, 61, 32, 64, 
	65, 90, 91, 96, 97, 122, 123, 126, 
	39, 102, 116, 32, 64, 65, 90, 91, 
	96, 97, 122, 123, 126, 39, 93, 32, 
	126, 39, 32, 126, 39, 93, 32, 126, 
	37, 39, 47, 91, 32, 126, 39, 95, 
	32, 126, 39, 80, 32, 126, 39, 65, 
	32, 126, 39, 84, 32, 126, 39, 72, 
	32, 126, 39, 95, 32, 126, 39, 69, 
	32, 126, 39, 78, 32, 126, 39, 68, 
	32, 126, 39, 95, 32, 126, 37, 39, 
	32, 126, 39, 42, 47, 32, 64, 65, 
	90, 91, 126, 37, 39, 47, 91, 32, 
	126, 39, 45, 64, 32, 47, 48, 57, 
	58, 126, 39, 32, 47, 48, 57, 58, 
	126, 39, 93, 32, 47, 48, 57, 58, 
	126, 37, 39, 47, 91, 32, 126, 39, 
	64, 32, 126, 39, 32, 64, 65, 90, 
	91, 96, 97, 122, 123, 126, 39, 61, 
	32, 64, 65, 90, 91, 96, 97, 122, 
	123, 126, 39, 102, 116, 32, 64, 65, 
	90, 91, 96, 97, 122, 123, 126, 39, 
	93, 32, 126, 39, 93, 32, 64, 65, 
	90, 91, 96, 97, 122, 123, 126, 37, 
	39, 47, 91, 32, 126, 39, 32, 64, 
	65, 90, 91, 96, 97, 122, 123, 126, 
	39, 61, 32, 64, 65, 90, 91, 96, 
	97, 122, 123, 126, 39, 102, 116, 32, 
	64, 65, 90, 91, 96, 97, 122, 123, 
	126, 39, 93, 32, 64, 65, 90, 91, 
	96, 97, 122, 123, 126, 39, 42, 32, 
	64, 65, 90, 91, 126, 39, 32, 64, 
	65, 90, 91, 96, 97, 122, 123, 126, 
	37, 39, 47, 91, 32, 64, 65, 90, 
	92, 96, 97, 122, 123, 126, 39, 45, 
	64, 32, 47, 48, 57, 58, 126, 39, 
	32, 47, 48, 57, 58, 126, 39, 93, 
	32, 47, 48, 57, 58, 126, 37, 39, 
	47, 32, 126, 39, 93, 32, 126, 39, 
	93, 32, 64, 65, 90, 91, 96, 97, 
	122, 123, 126, 37, 39, 47, 91, 32, 
	126, 39, 45, 64, 32, 47, 48, 57, 
	58, 126, 39, 32, 47, 48, 57, 58, 
	126, 39, 93, 32, 47, 48, 57, 58, 
	126, 37, 39, 47, 32, 126, 39, 42, 
	32, 64, 65, 90, 91, 126, 39, 32, 
	64, 65, 90, 91, 96, 97, 122, 123, 
	126, 37, 39, 47, 91, 32, 64, 65, 
	90, 92, 96, 97, 122, 123, 126, 93, 
	65, 90, 97, 122, 37, 47, 91, 65, 
	90, 97, 122, 61, 65, 90, 97, 122, 
	39, 102, 116, 65, 90, 97, 122, 32, 
	126, 93, 65, 90, 97, 122, 37, 47, 
	91, 45, 64, 48, 57, 48, 57, 93, 
	48, 57, 37, 47, 42, 65, 90, 65, 
	90, 97, 122, 37, 47, 91, 65, 90, 
	97, 122, 39, 32, 126, 39, 32, 126, 
	39, 32, 126, 39, 32, 126, 39, 32, 
	126, 0
};

static const char _query_path_single_lengths[] = {
	0, 3, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 3, 
	2, 2, 2, 2, 2, 2, 2, 2, 
	2, 2, 2, 3, 4, 3, 1, 2, 
	4, 2, 1, 2, 3, 3, 1, 4, 
	2, 2, 2, 2, 2, 2, 2, 2, 
	2, 2, 2, 3, 4, 3, 1, 2, 
	4, 2, 1, 2, 3, 4, 4, 2, 
	1, 2, 3, 4, 1, 4, 2, 2, 
	2, 2, 2, 2, 2, 2, 2, 2, 
	2, 3, 4, 3, 1, 2, 4, 2, 
	1, 2, 3, 4, 4, 3, 1, 2, 
	3, 1, 2, 3, 2, 2, 4, 2, 
	1, 4, 4, 2, 4, 3, 1, 2, 
	3, 2, 1, 4, 2, 4, 1, 2, 
	3, 3, 2, 4, 3, 1, 2, 2, 
	1, 4, 2, 3, 2, 0, 1, 3, 
	1, 0, 1, 3, 0, 1, 2, 4, 
	2, 2, 2, 2, 2, 2, 2, 2, 
	2, 2, 2, 3, 4, 3, 1, 2, 
	4, 2, 1, 2, 3, 2, 2, 1, 
	2, 3, 2, 1, 2, 4, 2, 2, 
	2, 2, 2, 2, 2, 2, 2, 2, 
	2, 3, 4, 3, 1, 2, 4, 2, 
	1, 2, 3, 2, 2, 4, 1, 2, 
	3, 2, 2, 1, 4, 3, 1, 2, 
	3, 2, 2, 4, 3, 1, 2, 3, 
	2, 1, 4, 1, 3, 0, 1, 3, 
	0, 1, 3, 2, 0, 1, 2, 1, 
	0, 3, 0, 1, 1, 1, 1, 1
};

static const char _query_path_range_lengths[] = {
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 3, 1, 3, 3, 3, 
	1, 1, 5, 5, 5, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 3, 1, 3, 3, 3, 
	1, 1, 5, 5, 5, 1, 1, 5, 
	5, 5, 5, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 3, 1, 3, 3, 3, 1, 1, 
	5, 5, 5, 1, 1, 3, 3, 3, 
	1, 5, 5, 5, 5, 5, 1, 3, 
	5, 5, 1, 5, 1, 3, 3, 3, 
	1, 3, 5, 5, 5, 1, 5, 5, 
	5, 1, 5, 1, 3, 3, 3, 3, 
	5, 5, 1, 0, 1, 1, 1, 0, 
	0, 2, 2, 2, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 3, 1, 3, 3, 3, 
	1, 1, 5, 5, 5, 1, 5, 5, 
	5, 5, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 3, 1, 3, 3, 3, 1, 1, 
	5, 5, 5, 1, 5, 1, 5, 5, 
	5, 5, 3, 5, 5, 3, 3, 3, 
	1, 1, 5, 1, 3, 3, 3, 1, 
	3, 5, 5, 2, 0, 2, 2, 2, 
	1, 2, 0, 1, 1, 1, 0, 1, 
	2, 2, 0, 1, 1, 1, 1, 1
};

static const short _query_path_index_offsets[] = {
	0, 0, 4, 6, 8, 10, 12, 14, 
	16, 18, 20, 22, 24, 26, 29, 32, 
	37, 41, 45, 49, 53, 57, 61, 65, 
	69, 73, 77, 81, 88, 94, 101, 106, 
	112, 118, 122, 129, 137, 146, 151, 154, 
	160, 164, 168, 172, 176, 180, 184, 188, 
	192, 196, 200, 204, 211, 217, 224, 229, 
	235, 241, 245, 252, 260, 269, 275, 281, 
	289, 296, 304, 313, 319, 322, 328, 332, 
	336, 340, 344, 348, 352, 356, 360, 364, 
	368, 372, 379, 385, 392, 397, 403, 409, 
	413, 420, 428, 437, 443, 449, 456, 461, 
	467, 472, 479, 487, 496, 504, 512, 518, 
	524, 531, 541, 547, 555, 561, 568, 573, 
	579, 584, 590, 597, 607, 615, 621, 628, 
	636, 645, 650, 658, 664, 671, 676, 682, 
	688, 695, 705, 709, 713, 717, 719, 722, 
	726, 728, 731, 735, 741, 743, 746, 750, 
	756, 760, 764, 768, 772, 776, 780, 784, 
	788, 792, 796, 800, 807, 813, 820, 825, 
	831, 837, 841, 848, 856, 865, 869, 877, 
	884, 892, 901, 905, 908, 912, 918, 922, 
	926, 930, 934, 938, 942, 946, 950, 954, 
	958, 962, 969, 975, 982, 987, 993, 999, 
	1003, 1010, 1018, 1027, 1031, 1039, 1045, 1052, 
	1060, 1069, 1077, 1083, 1090, 1100, 1107, 1112, 
	1118, 1123, 1127, 1135, 1141, 1148, 1153, 1159, 
	1164, 1170, 1177, 1187, 1191, 1195, 1198, 1202, 
	1208, 1210, 1214, 1218, 1222, 1224, 1227, 1230, 
	1233, 1236, 1242, 1243, 1246, 1249, 1252, 1255
};

static const unsigned char _query_path_trans_targs[] = {
	2, 13, 130, 0, 3, 0, 4, 0, 
	5, 0, 6, 0, 7, 0, 8, 0, 
	9, 0, 10, 0, 11, 0, 12, 0, 
	234, 0, 15, 14, 0, 15, 14, 0, 
	16, 15, 27, 14, 0, 15, 17, 14, 
	0, 15, 18, 14, 0, 15, 19, 14, 
	0, 15, 20, 14, 0, 15, 21, 14, 
	0, 15, 22, 14, 0, 15, 23, 14, 
	0, 15, 24, 14, 0, 15, 25, 14, 
	0, 15, 26, 14, 0, 235, 15, 14, 
	0, 15, 28, 127, 14, 128, 14, 0, 
	16, 15, 27, 29, 14, 0, 15, 30, 
	118, 14, 31, 14, 0, 15, 14, 31, 
	14, 0, 15, 32, 14, 31, 14, 0, 
	16, 15, 27, 33, 14, 0, 15, 34, 
	14, 0, 15, 14, 35, 14, 35, 14, 
	0, 15, 36, 14, 35, 14, 35, 14, 
	0, 37, 116, 116, 14, 116, 14, 116, 
	14, 0, 40, 112, 51, 38, 0, 39, 
	38, 0, 40, 39, 51, 62, 38, 0, 
	39, 41, 38, 0, 39, 42, 38, 0, 
	39, 43, 38, 0, 39, 44, 38, 0, 
	39, 45, 38, 0, 39, 46, 38, 0, 
	39, 47, 38, 0, 39, 48, 38, 0, 
	39, 49, 38, 0, 39, 50, 38, 0, 
	236, 39, 38, 0, 39, 52, 113, 38, 
	114, 38, 0, 40, 39, 51, 53, 38, 
	0, 39, 54, 64, 38, 55, 38, 0, 
	39, 38, 55, 38, 0, 39, 56, 38, 
	55, 38, 0, 40, 39, 51, 57, 38, 
	0, 39, 58, 38, 0, 39, 38, 59, 
	38, 59, 38, 0, 39, 60, 38, 59, 
	38, 59, 38, 0, 61, 63, 63, 38, 
	63, 38, 63, 38, 0, 40, 39, 51, 
	62, 38, 0, 40, 39, 51, 57, 38, 
	0, 39, 62, 38, 63, 38, 63, 38, 
	0, 39, 38, 65, 38, 65, 38, 0, 
	39, 66, 38, 65, 38, 65, 38, 0, 
	67, 107, 107, 38, 107, 38, 107, 38, 
	0, 70, 106, 81, 102, 68, 0, 69, 
	68, 0, 70, 69, 81, 92, 68, 0, 
	69, 71, 68, 0, 69, 72, 68, 0, 
	69, 73, 68, 0, 69, 74, 68, 0, 
	69, 75, 68, 0, 69, 76, 68, 0, 
	69, 77, 68, 0, 69, 78, 68, 0, 
	69, 79, 68, 0, 69, 80, 68, 0, 
	237, 69, 68, 0, 69, 82, 103, 68, 
	104, 68, 0, 70, 69, 81, 83, 68, 
	0, 69, 84, 97, 68, 85, 68, 0, 
	69, 68, 85, 68, 0, 69, 86, 68, 
	85, 68, 0, 70, 69, 81, 87, 68, 
	0, 69, 88, 68, 0, 69, 68, 89, 
	68, 89, 68, 0, 69, 90, 68, 89, 
	68, 89, 68, 0, 91, 101, 101, 68, 
	101, 68, 101, 68, 0, 70, 69, 81, 
	92, 68, 0, 70, 69, 81, 93, 68, 
	0, 69, 94, 97, 68, 95, 68, 0, 
	69, 68, 95, 68, 0, 69, 96, 68, 
	95, 68, 0, 70, 69, 81, 68, 0, 
	69, 68, 98, 68, 98, 68, 0, 69, 
	99, 68, 98, 68, 98, 68, 0, 91, 
	100, 100, 68, 100, 68, 100, 68, 0, 
	69, 92, 68, 100, 68, 100, 68, 0, 
	69, 102, 68, 101, 68, 101, 68, 0, 
	70, 69, 81, 87, 68, 0, 69, 82, 
	68, 104, 68, 0, 69, 68, 105, 68, 
	105, 68, 0, 70, 69, 81, 83, 68, 
	105, 68, 105, 68, 0, 70, 69, 81, 
	102, 68, 0, 39, 108, 38, 107, 38, 
	107, 38, 0, 40, 39, 51, 109, 38, 
	0, 39, 110, 64, 38, 111, 38, 0, 
	39, 38, 111, 38, 0, 39, 112, 38, 
	111, 38, 0, 40, 39, 51, 38, 0, 
	39, 52, 38, 114, 38, 0, 39, 38, 
	115, 38, 115, 38, 0, 40, 39, 51, 
	53, 38, 115, 38, 115, 38, 0, 15, 
	117, 14, 116, 14, 116, 14, 0, 16, 
	15, 27, 33, 14, 0, 15, 14, 119, 
	14, 119, 14, 0, 15, 120, 14, 119, 
	14, 119, 14, 0, 121, 122, 122, 14, 
	122, 14, 122, 14, 0, 70, 96, 81, 
	68, 0, 15, 123, 14, 122, 14, 122, 
	14, 0, 16, 15, 27, 124, 14, 0, 
	15, 125, 118, 14, 126, 14, 0, 15, 
	14, 126, 14, 0, 15, 15, 14, 126, 
	14, 0, 15, 28, 14, 128, 14, 0, 
	15, 14, 129, 14, 129, 14, 0, 16, 
	15, 27, 29, 14, 129, 14, 129, 14, 
	0, 131, 231, 232, 0, 2, 130, 132, 
	0, 133, 221, 134, 0, 134, 0, 135, 
	134, 0, 2, 130, 136, 0, 137, 0, 
	138, 138, 0, 139, 138, 138, 0, 140, 
	219, 219, 219, 219, 0, 141, 0, 142, 
	141, 0, 142, 143, 141, 0, 144, 142, 
	155, 161, 141, 0, 142, 145, 141, 0, 
	142, 146, 141, 0, 142, 147, 141, 0, 
	142, 148, 141, 0, 142, 149, 141, 0, 
	142, 150, 141, 0, 142, 151, 141, 0, 
	142, 152, 141, 0, 142, 153, 141, 0, 
	142, 154, 141, 0, 238, 142, 141, 0, 
	142, 156, 216, 141, 217, 141, 0, 144, 
	142, 155, 157, 141, 0, 142, 158, 167, 
	141, 159, 141, 0, 142, 141, 159, 141, 
	0, 142, 160, 141, 159, 141, 0, 144, 
	142, 155, 161, 141, 0, 142, 162, 141, 
	0, 142, 141, 163, 141, 163, 141, 0, 
	142, 164, 141, 163, 141, 163, 141, 0, 
	165, 166, 166, 141, 166, 141, 166, 141, 
	0, 142, 143, 141, 0, 142, 143, 141, 
	166, 141, 166, 141, 0, 142, 141, 168, 
	141, 168, 141, 0, 142, 169, 141, 168, 
	141, 168, 141, 0, 170, 210, 210, 141, 
	210, 141, 210, 141, 0, 209, 197, 171, 
	0, 172, 171, 0, 172, 173, 171, 0, 
	174, 172, 185, 205, 171, 0, 172, 175, 
	171, 0, 172, 176, 171, 0, 172, 177, 
	171, 0, 172, 178, 171, 0, 172, 179, 
	171, 0, 172, 180, 171, 0, 172, 181, 
	171, 0, 172, 182, 171, 0, 172, 183, 
	171, 0, 172, 184, 171, 0, 239, 172, 
	171, 0, 172, 186, 202, 171, 203, 171, 
	0, 174, 172, 185, 187, 171, 0, 172, 
	188, 198, 171, 189, 171, 0, 172, 171, 
	189, 171, 0, 172, 190, 171, 189, 171, 
	0, 174, 172, 185, 191, 171, 0, 172, 
	192, 171, 0, 172, 171, 193, 171, 193, 
	171, 0, 172, 194, 171, 193, 171, 193, 
	171, 0, 195, 196, 196, 171, 196, 171, 
	196, 171, 0, 172, 173, 171, 0, 172, 
	197, 171, 196, 171, 196, 171, 0, 174, 
	172, 185, 191, 171, 0, 172, 171, 199, 
	171, 199, 171, 0, 172, 200, 171, 199, 
	171, 199, 171, 0, 195, 201, 201, 171, 
	201, 171, 201, 171, 0, 172, 173, 171, 
	201, 171, 201, 171, 0, 172, 186, 171, 
	203, 171, 0, 172, 171, 204, 171, 204, 
	171, 0, 174, 172, 185, 187, 171, 204, 
	171, 204, 171, 0, 172, 206, 198, 171, 
	207, 171, 0, 172, 171, 207, 171, 0, 
	172, 208, 171, 207, 171, 0, 174, 172, 
	185, 171, 0, 172, 197, 171, 0, 142, 
	211, 141, 210, 141, 210, 141, 0, 144, 
	142, 155, 212, 141, 0, 142, 213, 167, 
	141, 214, 141, 0, 142, 141, 214, 141, 
	0, 142, 215, 141, 214, 141, 0, 144, 
	142, 155, 141, 0, 142, 156, 141, 217, 
	141, 0, 142, 141, 218, 141, 218, 141, 
	0, 144, 142, 155, 157, 141, 218, 141, 
	218, 141, 0, 220, 219, 219, 0, 2, 
	130, 136, 0, 222, 222, 0, 223, 222, 
	222, 0, 224, 225, 225, 225, 225, 0, 
	171, 0, 226, 225, 225, 0, 2, 130, 
	227, 0, 228, 221, 229, 0, 229, 0, 
	230, 229, 0, 2, 130, 0, 131, 232, 
	0, 233, 233, 0, 2, 130, 132, 233, 
	233, 0, 0, 15, 14, 0, 39, 38, 
	0, 69, 68, 0, 142, 141, 0, 172, 
	171, 0, 0
};

static const char _query_path_trans_actions[] = {
	0, 0, 0, 13, 0, 13, 0, 13, 
	0, 13, 0, 13, 0, 13, 0, 13, 
	0, 13, 0, 13, 0, 13, 0, 13, 
	0, 13, 35, 11, 13, 15, 0, 13, 
	0, 15, 0, 0, 13, 15, 0, 0, 
	13, 15, 0, 0, 13, 15, 0, 0, 
	13, 15, 0, 0, 13, 15, 0, 0, 
	13, 15, 0, 0, 13, 15, 0, 0, 
	13, 15, 0, 0, 13, 15, 0, 0, 
	13, 15, 0, 0, 13, 0, 15, 0, 
	13, 15, 25, 0, 0, 44, 0, 13, 
	23, 15, 23, 23, 0, 13, 15, 11, 
	0, 0, 11, 0, 13, 15, 0, 0, 
	0, 13, 15, 19, 0, 0, 0, 13, 
	0, 15, 0, 0, 0, 13, 15, 0, 
	0, 13, 15, 0, 1, 0, 1, 0, 
	13, 15, 3, 0, 0, 0, 0, 0, 
	13, 15, 32, 32, 0, 7, 0, 7, 
	0, 13, 5, 38, 5, 5, 13, 41, 
	0, 13, 0, 41, 0, 0, 0, 13, 
	41, 0, 0, 13, 41, 0, 0, 13, 
	41, 0, 0, 13, 41, 0, 0, 13, 
	41, 0, 0, 13, 41, 0, 0, 13, 
	41, 0, 0, 13, 41, 0, 0, 13, 
	41, 0, 0, 13, 41, 0, 0, 13, 
	0, 41, 0, 13, 41, 25, 0, 0, 
	44, 0, 13, 23, 41, 23, 23, 0, 
	13, 41, 11, 0, 0, 11, 0, 13, 
	41, 0, 0, 0, 13, 41, 19, 0, 
	0, 0, 13, 0, 41, 0, 0, 0, 
	13, 41, 0, 0, 13, 41, 0, 1, 
	0, 1, 0, 13, 41, 3, 0, 0, 
	0, 0, 0, 13, 41, 32, 32, 0, 
	7, 0, 7, 0, 13, 5, 50, 5, 
	5, 5, 13, 21, 41, 21, 21, 0, 
	13, 41, 9, 0, 0, 0, 0, 0, 
	13, 41, 0, 1, 0, 1, 0, 13, 
	41, 3, 0, 0, 0, 0, 0, 13, 
	41, 32, 32, 0, 7, 0, 7, 0, 
	13, 5, 50, 5, 5, 5, 13, 41, 
	0, 13, 0, 41, 0, 0, 0, 13, 
	41, 0, 0, 13, 41, 0, 0, 13, 
	41, 0, 0, 13, 41, 0, 0, 13, 
	41, 0, 0, 13, 41, 0, 0, 13, 
	41, 0, 0, 13, 41, 0, 0, 13, 
	41, 0, 0, 13, 41, 0, 0, 13, 
	0, 41, 0, 13, 41, 25, 0, 0, 
	44, 0, 13, 23, 41, 23, 23, 0, 
	13, 41, 11, 0, 0, 11, 0, 13, 
	41, 0, 0, 0, 13, 41, 19, 0, 
	0, 0, 13, 0, 41, 0, 0, 0, 
	13, 41, 0, 0, 13, 41, 0, 1, 
	0, 1, 0, 13, 41, 3, 0, 0, 
	0, 0, 0, 13, 41, 32, 32, 0, 
	7, 0, 7, 0, 13, 5, 50, 5, 
	5, 5, 13, 21, 41, 21, 21, 0, 
	13, 41, 11, 0, 0, 11, 0, 13, 
	41, 0, 0, 0, 13, 41, 19, 0, 
	0, 0, 13, 0, 41, 0, 0, 13, 
	41, 0, 1, 0, 1, 0, 13, 41, 
	3, 0, 0, 0, 0, 0, 13, 41, 
	32, 32, 0, 7, 0, 7, 0, 13, 
	41, 9, 0, 0, 0, 0, 0, 13, 
	41, 9, 0, 0, 0, 0, 0, 13, 
	21, 41, 21, 21, 0, 13, 41, 27, 
	0, 47, 0, 13, 41, 0, 0, 0, 
	0, 0, 13, 17, 41, 17, 17, 0, 
	0, 0, 0, 0, 13, 0, 41, 0, 
	0, 0, 13, 41, 9, 0, 0, 0, 
	0, 0, 13, 21, 41, 21, 21, 0, 
	13, 41, 11, 0, 0, 11, 0, 13, 
	41, 0, 0, 0, 13, 41, 19, 0, 
	0, 0, 13, 0, 41, 0, 0, 13, 
	41, 27, 0, 47, 0, 13, 41, 0, 
	0, 0, 0, 0, 13, 17, 41, 17, 
	17, 0, 0, 0, 0, 0, 13, 15, 
	9, 0, 0, 0, 0, 0, 13, 21, 
	15, 21, 21, 0, 13, 15, 0, 1, 
	0, 1, 0, 13, 15, 3, 0, 0, 
	0, 0, 0, 13, 15, 32, 32, 0, 
	7, 0, 7, 0, 13, 5, 38, 5, 
	5, 13, 15, 9, 0, 0, 0, 0, 
	0, 13, 21, 15, 21, 21, 0, 13, 
	15, 11, 0, 0, 11, 0, 13, 15, 
	0, 0, 0, 13, 15, 19, 0, 0, 
	0, 13, 15, 27, 0, 47, 0, 13, 
	15, 0, 0, 0, 0, 0, 13, 17, 
	15, 17, 17, 0, 0, 0, 0, 0, 
	13, 25, 0, 44, 13, 23, 23, 23, 
	13, 11, 0, 11, 13, 0, 13, 19, 
	0, 13, 0, 0, 0, 13, 0, 13, 
	1, 1, 13, 3, 0, 0, 13, 0, 
	32, 32, 7, 7, 13, 5, 13, 9, 
	0, 13, 9, 0, 0, 13, 21, 9, 
	21, 21, 0, 13, 9, 0, 0, 13, 
	9, 0, 0, 13, 9, 0, 0, 13, 
	9, 0, 0, 13, 9, 0, 0, 13, 
	9, 0, 0, 13, 9, 0, 0, 13, 
	9, 0, 0, 13, 9, 0, 0, 13, 
	9, 0, 0, 13, 0, 9, 0, 13, 
	9, 25, 0, 0, 44, 0, 13, 23, 
	9, 23, 23, 0, 13, 9, 11, 0, 
	0, 11, 0, 13, 9, 0, 0, 0, 
	13, 9, 19, 0, 0, 0, 13, 0, 
	9, 0, 0, 0, 13, 9, 0, 0, 
	13, 9, 0, 1, 0, 1, 0, 13, 
	9, 3, 0, 0, 0, 0, 0, 13, 
	9, 32, 32, 0, 7, 0, 7, 0, 
	13, 29, 5, 5, 13, 9, 9, 0, 
	0, 0, 0, 0, 13, 9, 0, 1, 
	0, 1, 0, 13, 9, 3, 0, 0, 
	0, 0, 0, 13, 9, 32, 32, 0, 
	7, 0, 7, 0, 13, 29, 5, 5, 
	13, 9, 0, 13, 9, 0, 0, 13, 
	21, 9, 21, 21, 0, 13, 9, 0, 
	0, 13, 9, 0, 0, 13, 9, 0, 
	0, 13, 9, 0, 0, 13, 9, 0, 
	0, 13, 9, 0, 0, 13, 9, 0, 
	0, 13, 9, 0, 0, 13, 9, 0, 
	0, 13, 9, 0, 0, 13, 0, 9, 
	0, 13, 9, 25, 0, 0, 44, 0, 
	13, 23, 9, 23, 23, 0, 13, 9, 
	11, 0, 0, 11, 0, 13, 9, 0, 
	0, 0, 13, 9, 19, 0, 0, 0, 
	13, 0, 9, 0, 0, 0, 13, 9, 
	0, 0, 13, 9, 0, 1, 0, 1, 
	0, 13, 9, 3, 0, 0, 0, 0, 
	0, 13, 9, 32, 32, 0, 7, 0, 
	7, 0, 13, 29, 5, 5, 13, 9, 
	9, 0, 0, 0, 0, 0, 13, 21, 
	9, 21, 21, 0, 13, 9, 0, 1, 
	0, 1, 0, 13, 9, 3, 0, 0, 
	0, 0, 0, 13, 9, 32, 32, 0, 
	7, 0, 7, 0, 13, 9, 9, 0, 
	0, 0, 0, 0, 13, 9, 27, 0, 
	47, 0, 13, 9, 0, 0, 0, 0, 
	0, 13, 17, 9, 17, 17, 0, 0, 
	0, 0, 0, 13, 9, 11, 0, 0, 
	11, 0, 13, 9, 0, 0, 0, 13, 
	9, 19, 0, 0, 0, 13, 0, 9, 
	0, 0, 13, 9, 0, 0, 13, 9, 
	9, 0, 0, 0, 0, 0, 13, 21, 
	9, 21, 21, 0, 13, 9, 11, 0, 
	0, 11, 0, 13, 9, 0, 0, 0, 
	13, 9, 19, 0, 0, 0, 13, 0, 
	9, 0, 0, 13, 9, 27, 0, 47, 
	0, 13, 9, 0, 0, 0, 0, 0, 
	13, 17, 9, 17, 17, 0, 0, 0, 
	0, 0, 13, 9, 0, 0, 13, 21, 
	21, 21, 13, 1, 1, 13, 3, 0, 
	0, 13, 0, 32, 32, 7, 7, 13, 
	5, 13, 9, 0, 0, 13, 21, 21, 
	21, 13, 11, 0, 11, 13, 0, 13, 
	19, 0, 13, 0, 0, 13, 27, 47, 
	13, 0, 0, 13, 17, 17, 17, 0, 
	0, 13, 0, 15, 0, 0, 41, 0, 
	0, 41, 0, 0, 9, 0, 0, 9, 
	0, 0, 0
};

static const char _query_path_eof_actions[] = {
	0, 13, 13, 13, 13, 13, 13, 13, 
	13, 13, 13, 13, 13, 13, 13, 13, 
	13, 13, 13, 13, 13, 13, 13, 13, 
	13, 13, 13, 13, 13, 13, 13, 13, 
	13, 13, 13, 13, 13, 13, 13, 13, 
	13, 13, 13, 13, 13, 13, 13, 13, 
	13, 13, 13, 13, 13, 13, 13, 13, 
	13, 13, 13, 13, 13, 13, 13, 13, 
	13, 13, 13, 13, 13, 13, 13, 13, 
	13, 13, 13, 13, 13, 13, 13, 13, 
	13, 13, 13, 13, 13, 13, 13, 13, 
	13, 13, 13, 13, 13, 13, 13, 13, 
	13, 13, 13, 13, 13, 13, 13, 13, 
	13, 13, 13, 13, 13, 13, 13, 13, 
	13, 13, 13, 13, 13, 13, 13, 13, 
	13, 13, 13, 13, 13, 13, 13, 13, 
	13, 13, 13, 13, 13, 13, 13, 13, 
	13, 13, 13, 13, 13, 13, 13, 13, 
	13, 13, 13, 13, 13, 13, 13, 13, 
	13, 13, 13, 13, 13, 13, 13, 13, 
	13, 13, 13, 13, 13, 13, 13, 13, 
	13, 13, 13, 13, 13, 13, 13, 13, 
	13, 13, 13, 13, 13, 13, 13, 13, 
	13, 13, 13, 13, 13, 13, 13, 13, 
	13, 13, 13, 13, 13, 13, 13, 13, 
	13, 13, 13, 13, 13, 13, 13, 13, 
	13, 13, 13, 13, 13, 13, 13, 13, 
	13, 13, 13, 13, 13, 13, 13, 13, 
	13, 13, 13, 13, 13, 13, 13, 13, 
	13, 13, 0, 0, 0, 0, 0, 0
};

static const int query_path_start = 1;
static const int query_path_first_final = 234;
static const int query_path_error = 0;

static const int query_path_en_main = 1;


#line 22 "Source/UIBaconPath.m.rl"


@implementation UIBaconPath

+ (id)viewsByPath:(NSString *)path ofView:(BACON_VIEW *)view {
  id result = view;

  NSString *_path = [path stringByAppendingString:@"%_PATH_END_%"];

  int cs = 0;
  char *ts = 0;
  char *pe = 0;
  char *p = (char *)[_path UTF8String];
  char *eof = p + (char)[_path length];

  //char *start = p;

  // property name & value start/end
  char *pns = 0;
  char *pne = 0;
  char *pvs = 0;
  char *pve = 0;
  int type = STRING;

  BOOL traverse = NO;
  NSString *current;

  BACON_VIEW *v;

  
#line 757 "Source/UIBaconPath.m"
	{
	cs = query_path_start;
	}

#line 762 "Source/UIBaconPath.m"
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
	cs = _query_path_trans_targs[_trans];

	if ( _query_path_trans_actions[_trans] == 0 )
		goto _again;

	_acts = _query_path_actions + _query_path_trans_actions[_trans];
	_nacts = (unsigned int) *_acts++;
	while ( _nacts-- > 0 )
	{
		switch ( *_acts++ )
		{
	case 0:
#line 52 "Source/UIBaconPath.m.rl"
	{ pns = p; }
	break;
	case 1:
#line 53 "Source/UIBaconPath.m.rl"
	{ pne = p; }
	break;
	case 2:
#line 56 "Source/UIBaconPath.m.rl"
	{ type = STRING; pvs = p; }
	break;
	case 3:
#line 59 "Source/UIBaconPath.m.rl"
	{ type = BOOLEAN; pvs = p; }
	break;
	case 4:
#line 62 "Source/UIBaconPath.m.rl"
	{ type = VARIABLE; pvs = p; }
	break;
	case 5:
#line 65 "Source/UIBaconPath.m.rl"
	{ pve = p; }
	break;
	case 6:
#line 68 "Source/UIBaconPath.m.rl"
	{
      ts = p;
    }
	break;
	case 7:
#line 72 "Source/UIBaconPath.m.rl"
	{
      NSLog(@"A parse error occurred in: %@", path);
      return nil;
    }
	break;
	case 8:
#line 77 "Source/UIBaconPath.m.rl"
	{
      AUTO_FILTER();
      if ([current length] == 0) {
        NSLog(@"An empty name value was encountered while parsing: %@", path);
        return nil;
      }
      result = [view viewByName:current];
      // TODO
      //NSLog(@"raise if an element name is not at the start of the path!");
    }
	break;
	case 9:
#line 88 "Source/UIBaconPath.m.rl"
	{
      AUTO_FILTER();
      if ([result isKindOfClass:[BACON_VIEW class]]) {
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
	case 10:
#line 105 "Source/UIBaconPath.m.rl"
	{
      AUTO_FILTER();
      result = [result index:[current integerValue]];
    }
	break;
	case 11:
#line 121 "Source/UIBaconPath.m.rl"
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

      if ([result isKindOfClass:[BACON_VIEW class]]) {
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
	case 12:
#line 153 "Source/UIBaconPath.m.rl"
	{
      NSArray *r;
      if ([result isKindOfClass:[BACON_VIEW class]]) {
        r = [self _collectSubviews:[NSArray arrayWithObject:result] recursive:traverse];
      } else {
        r = [self _collectSubviews:[(UIBaconViewSet *)result array] recursive:traverse];
      }
      result = [[[UIBaconViewSet alloc] initWithArray:r] autorelease];
    }
	break;
	case 13:
#line 163 "Source/UIBaconPath.m.rl"
	{
      traverse = NO;
    }
	break;
	case 14:
#line 167 "Source/UIBaconPath.m.rl"
	{
      traverse = YES;
    }
	break;
#line 969 "Source/UIBaconPath.m"
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
	case 7:
#line 72 "Source/UIBaconPath.m.rl"
	{
      NSLog(@"A parse error occurred in: %@", path);
      return nil;
    }
	break;
#line 992 "Source/UIBaconPath.m"
		}
	}
	}

	_out: {}
	}

#line 196 "Source/UIBaconPath.m.rl"


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
  for (BACON_VIEW *v in views) {
    NSArray *subviews = [v subviews];
    [result addObjectsFromArray:subviews];
    if (recursive) {
      [result addObjectsFromArray:[self _collectSubviews:subviews recursive:YES]];
    }
  }
  return result;
}

@end
