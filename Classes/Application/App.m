

#import "App.h"
#import "IFRemoteData.h"
#import "ASIDownloadCache.h"
#import "SBJson.h"



///////////////////////////////////////////////////////////////////////////////////////////////////
@implementation App

@synthesize requestsQueue, locationManager, locationDelegate, remoteData, gasVendors;
@synthesize phoneEsAssistance,phoneEsSkipper,phoneHakAssistance,phoneHakCustomerService,assistanceGpsThreshold,clubsClosestCount,adsInterval;
static App* _instance = nil;


///////////////////////////////////////////////////////////////////////////////////////////////////
+ (App*) instance
{
    @synchronized(self) 
    {
        if (_instance == nil) 
        {
            _instance = [[self alloc] init]; 
        }
    }
    return _instance;
}


- (id)init
{
    if(self == [super init]) 
    {
        DLog(@"init application");

        requestsQueue = [[ASINetworkQueue alloc] init];
        
        [ASIHTTPRequest setDefaultTimeOutSeconds:30];
        [ASIHTTPRequest setDefaultCache:[ASIDownloadCache sharedCache]];    
        [requestsQueue setShouldCancelAllRequestsOnFailure:NO];
        [requestsQueue setMaxConcurrentOperationCount:4];
        [requestsQueue go];
        
        locationManager = [[CLLocationManager alloc] init];
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
        locationManager.distanceFilter = kCLDistanceFilterNone;
        locationManager.delegate = self;
        [locationManager startUpdatingLocation];
        [locationManager startMonitoringSignificantLocationChanges];
         gasVendors = [[NSMutableDictionary alloc] init];
    
    }
    return self;
}


- (void)loadApplicationData
{
    remoteData = [[NSMutableDictionary alloc] init];
    
    IFRemoteData *data2 = [[IFRemoteData alloc] initWithURL:[Util urlForApi:@"prometinfo" params:nil useHttps:kApiUseHttps]];
    data2.key = @"traficinfo";
    [data2 downloadInBackground];
    data2.cachingInterval =  kCacheIntervalShort;
    [remoteData setObject:data2 forKey:data2.key];
    [data2 release];
    
    IFRemoteData *data = [[IFRemoteData alloc] initWithURL:[Util urlForApi:@"cams" params:nil useHttps:kApiUseHttps]];
    data.key = @"cameras";
    data.permanentCache = YES;
    data.cachingInterval = kCacheIntervalShort;
    [data downloadInBackground];
    [remoteData setObject:data forKey:data.key];
    [data release];
    
    IFRemoteData *data4 = [[IFRemoteData alloc] initWithURL:[Util urlForApi:@"fuelprices" params:nil useHttps:kApiUseHttps]];
    data4.key = @"gas";
    data4.cachingInterval =  kCacheIntervalMedium;
    [data4 downloadInBackground];
    [remoteData setObject:data4 forKey:data4.key];
    [data4 release];
    
    IFRemoteData *data1 = [[IFRemoteData alloc] initWithURL:[Util urlForApi:@"clubs" params:nil useHttps:kApiUseHttps]];
    data1.key = @"clubs";
    data1.permanentCache = YES;
    data1.cachingInterval = kCacheIntervalLong;
    [data1 downloadInBackground];
    [remoteData setObject:data1 forKey:data1.key];
    [data1 release];
    
    
    IFRemoteData *data3 = [[IFRemoteData alloc] initWithURL:[Util urlForApi:@"partners2" params:nil useHttps:kApiUseHttps]];
    data3.key = @"partners";
    data3.permanentCache = YES;
    data3.cachingInterval = kCacheIntervalLong;
    [data3 downloadInBackground];
    [remoteData setObject:data3 forKey:data3.key];
    [data3 release];
    
    //load config data, ako je vec postoje onda pokusaj osveziti sa neta, inace hardkodiraj pa pokusaj osvjeziti sa neta
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"configHasBeenSet"] == nil) {
        [[NSUserDefaults standardUserDefaults] setValue:@"Set" forKey:@"configHasBeenSet"];
        
        [self dataDidLoad:@"[{\"Phone_HAK_Assistance\":\"+38511987\",\"Phone_HAK_CustomerService\":\"08009987\",\"Phone_ES_Assistance\":\"+38598306609\",\"Phone_ES_Skipper\":\"+38598306609\",\"Assistance_GpsThreshold\":50,\"Clubs_ClosestCount\":5,\"Ads_Interval\":3000}]"];
    }
    
    data5 = [[IFRemoteData alloc] initWithURL:[Util urlForApi:@"config" params:nil useHttps:kApiUseHttps]];
    data5.permanentCache = YES;
    data5.delegate = self;
    [data5 downloadInBackground];
    
}

-(void)dataDidLoad:(NSString *)data{
    
    [data5 release];
    
    if (data == NULL) {
        data = @"[{\"Phone_HAK_Assistance\":\"+38511987\",\"Phone_HAK_CustomerService\":\"08009987\",\"Phone_ES_Assistance\":\"+38598306609\",\"Phone_ES_Skipper\":\"+38598306609\",\"Assistance_GpsThreshold\":50,\"Clubs_ClosestCount\":5,\"Ads_Interval\":3000}]";
    }
    NSDictionary *configData = [[[data JSONValue] objectAtIndex:0] retain];
    
    for (NSString *key in [configData allKeys]) {
        [[NSUserDefaults standardUserDefaults] setValue:[configData objectForKey:key] forKey:key];
    }
    
    phoneHakAssistance = [configData objectForKey:@"Phone_HAK_Assistance"];
    phoneHakCustomerService = [configData objectForKey:@"Phone_HAK_CustomerService"];
    phoneEsAssistance = [configData objectForKey:@"Phone_ES_Assistance"];
    phoneEsSkipper = [configData objectForKey:@"Phone_ES_Assistance"];
    assistanceGpsThreshold = [[configData objectForKey:@"Assistance_GpsThreshold"] intValue];
    clubsClosestCount = [[configData objectForKey:@"Clubs_ClosestCount"] intValue];
    adsInterval = [[configData objectForKey:@"Ads_Interval"] intValue];
    
    [configData release];
    
    
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    if (locationDelegate) {
        [locationDelegate locationManager:manager didUpdateToLocation:newLocation fromLocation:oldLocation];
    }
    if (newLocation.horizontalAccuracy<25) {
        [locationManager stopUpdatingLocation];
    }else{
        [locationManager startUpdatingLocation];
    }
    #if TARGET_IPHONE_SIMULATOR
         [locationManager stopUpdatingLocation];
    #endif
 //   DLog(@"Location update: %+.6f, %+.6f (%+.2f)!", newLocation.coordinate.latitude, newLocation.coordinate.longitude, newLocation.horizontalAccuracy);
}

-(void)removeLocationDelegate:(id<CLLocationManagerDelegate>) delegateToRemove{
    if (delegateToRemove==self.locationDelegate){
        locationDelegate = nil;
    }
}

- (id)retain
{
    return self;
}


- (unsigned)retainCount
{
    return UINT_MAX;  //denotes an object that cannot be released
}


- (void)release
{
    //do nothing
}


- (id)autorelease
{
    return self;
}

@end

