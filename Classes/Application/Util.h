//
//  Util.h
//  HAK
//
//  Created by Matej Spoler on 5/19/11.
//  Copyright 2011 Infinum. All rights reserved.
//

#import <Foundation/Foundation.h>
#define kLongitudeType 1
#define kLatitudeType 2

@interface Util : NSObject {
    
}

+(NSURL*)urlForApi:(NSString*)model params:(NSString*)params useHttps:(BOOL)useHttps;
+(NSString*)formatGpsCoordinatesIntoDegrees:(double)latitudeOrLongitude type:(int)type;
+(void)showConnectitivityWarning;

@end
