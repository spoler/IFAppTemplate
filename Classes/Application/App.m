
#import "App.h"


///////////////////////////////////////////////////////////////////////////////////////////////////
@implementation App

@synthesize remoteData;
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

    }
    return self;
}


- (void)loadApplicationData
{
    remoteData = [[NSMutableDictionary alloc] init];
    
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

