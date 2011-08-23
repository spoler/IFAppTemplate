
#import "App.h"
#import "ASINetworkQueue.h"
#import "IFRemoteData.h"
#import "ASIDownloadCache.h"


///////////////////////////////////////////////////////////////////////////////////////////////////
@implementation App

@synthesize requestsQueue, remoteData;
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
        DDLogCInfo(@"Aplication init");

        requestsQueue = [[ASINetworkQueue alloc] init];
        [ASIHTTPRequest setDefaultTimeOutSeconds:30];
        [ASIHTTPRequest setDefaultCache:[ASIDownloadCache sharedCache]];    
        [requestsQueue setShouldCancelAllRequestsOnFailure:NO];
        [requestsQueue setMaxConcurrentOperationCount:4];
        [requestsQueue go];
    }
    return self;
}


- (void)loadApplicationData
{
    remoteData = [[NSMutableDictionary alloc] init];
    
/*    
    IFRemoteData *data1 = [[IFRemoteData alloc] initWithURL:@"http://example.com"];
    data1.key = @"clubs";
    data1.permanentCache = YES;
    [data1 downloadInBackground];
    [remoteData setObject:data1 forKey:data1.key];
    [data1 release];
 */
    
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

