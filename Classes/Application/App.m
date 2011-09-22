
#import "App.h"


///////////////////////////////////////////////////////////////////////////////////////////////////
@implementation App

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
        DDLogInfo(@"Aplication init");
        [self loadApplicationData];

    }
    return self;
}


- (void)loadApplicationData
{
    
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

