
#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "ASINetworkQueue.h"
#import "AppDefines.h"
#import "IFRemoteData.h"
#import "Util.h"

@interface App  : NSObject <CLLocationManagerDelegate, IFRemoteDataDelegate>
{
@private
    IFRemoteData *data5;
}

+ (App*) instance;
- (void) loadApplicationData;
-(void)removeLocationDelegate:(id<CLLocationManagerDelegate>) delegateToRemove;

@property (retain) ASINetworkQueue* requestsQueue;
@property (nonatomic, retain) CLLocationManager* locationManager;
@property (nonatomic, retain) NSMutableDictionary* remoteData;
@property (nonatomic, retain) NSMutableDictionary* gasVendors;
@property (assign) id <CLLocationManagerDelegate> locationDelegate;

@property (nonatomic, retain) NSString *phoneHakAssistance;
@property (nonatomic, retain) NSString *phoneHakCustomerService;
@property (nonatomic, retain) NSString *phoneEsAssistance;
@property (nonatomic, retain) NSString *phoneEsSkipper;
@property (nonatomic, assign) NSInteger assistanceGpsThreshold;
@property (nonatomic, assign) NSInteger clubsClosestCount;
@property (nonatomic, assign) NSInteger adsInterval;

@end
