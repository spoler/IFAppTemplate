
#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "PSFoundation/PSFoundation.h"
#import "AppDefines.h"



@class ASINetworkQueue;

@interface App  : NSObject
{
}

+ (App*) instance;
- (void) loadApplicationData;

@property (nonatomic, retain) NSMutableDictionary* remoteData;

@end
