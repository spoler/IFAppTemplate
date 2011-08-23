//
//  AppDefines.h
//  HAK
//
//  Created by Matej Spoler on 5/18/11.
//  Copyright 2011 Infinum. All rights reserved.
//

#ifdef DEBUG
#   define DLog(...) NSLog(__VA_ARGS__)
#else
#   define DLog(...) /* */
#endif

#define kMaxDataRetryCount 3
#define kMaxImageRetryCount 2

#define kApiToken @"78727ea3081821"
#define kApiVersion @"1.0"
#define kApiUseHttps YES
#define kMapDefaultZoom 3

//15 min
#define kCacheIntervalShort 900
//3 h
#define kCacheIntervalMedium 10800
//3 days
#define kCacheIntervalLong 259200
