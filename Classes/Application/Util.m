//
//  Util.m
//  HAK
//
//  Created by Matej Spoler on 5/19/11.
//  Copyright 2011 Infinum. All rights reserved.
//

#import "Util.h"
#import "AppDefines.h"


@implementation Util

+(NSURL*)urlForApi:(NSString*)model params:(NSString*)params useHttps:(BOOL)useHttps{
    NSMutableString* fullUrl = [[NSMutableString alloc] init];
    if (useHttps) {
        [fullUrl appendString:@"https://"];
    }else{
        [fullUrl appendString:@"http://"];
    }
    [fullUrl appendString:@"api.hak.hr/rest/"];
    [fullUrl appendFormat:@"%@/", model];
    if (params) {
        [fullUrl appendString:params];
        [fullUrl appendString:@"/"];
    }
    [fullUrl appendFormat:@"?token=%@&version=%@", kApiToken, kApiVersion];
    NSURL* url = [NSURL URLWithString:fullUrl];
    [fullUrl release];
    return url;
}

+(void)showConnectitivityWarning{
    UIAlertView *alert1 = [[UIAlertView alloc] initWithTitle:@"Greška"
                                                     message:@"Aplikacija nije u mogućnosti dohvatiti podatke s Interneta. Provjerite postavke ili pokušajte kasnije."
                                                    delegate:nil
                                           cancelButtonTitle:@"OK"
                                           otherButtonTitles:nil];
    [alert1 show];
    
}

+(NSString*)formatGpsCoordinatesIntoDegrees:(double)latitudeOrLongitude type:(int)type{
    NSString *prefix;
    if (type == kLongitudeType) {
        if (latitudeOrLongitude > 0) {
            prefix = @"E:";
        } else {
            prefix = @"W:";
        }
    } else {
        if (latitudeOrLongitude > 0) {
            prefix = @"N:";
        } else {
            prefix = @"S:";
        }
    }
    if (latitudeOrLongitude < 0)
        latitudeOrLongitude += 360;
    int degrees = (int) latitudeOrLongitude;
    double minutesFloat = 60 * (latitudeOrLongitude - degrees);
    int minutes = (int) minutesFloat;
    double secondsFloat = 60 * (minutesFloat - minutes);
    int seconds = (int) secondsFloat;
    if (seconds == 60) {
        minutes += 1;
        seconds = 0;
    }
    if (minutes == 60) {
        degrees += 1;
        minutes = 0;
    }
    return [NSString stringWithFormat:@"%@ %i°%i'%i''", prefix, degrees, minutes, seconds];
}

@end
