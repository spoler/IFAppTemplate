//
//  RemoteData.m
//  HAK
//
//  Created by Matej Spoler on 5/18/11.
//  Copyright 2011 Infinum. All rights reserved.
//

#import "IFRemoteData.h"
#import "App.h"
#import "ASIHTTPRequest.h"

@implementation IFRemoteData

@synthesize delegate;
@synthesize url, useCache, cachedData, permanentCache, isValid, key, isDownloading, cachingInterval;
@dynamic validCache;

-(id)initWithURL:(NSURL*)__url{
    self = [super init];
    if (self) {
        self.url = __url;
        if (__url!=nil && [[__url relativeString] length]>10) {
            isValid = YES;
        }else{
            isValid = NO;
        }
        isDownloading = NO;
        useCache = NO;
        permanentCache = NO;
    }
    return self;
}

-(void)removeDelegate:(id<IFRemoteDataDelegate>) delegateToRemove{
    if (delegateToRemove==self.delegate){
        self.delegate = nil;
    }
}


-(BOOL)validCache{
  /*  if (createdAt && cachingInterval>0) {
        if ([createdAt timeIntervalSinceNow]<(-cachingInterval)) {
            _validCache = NO;
        }
    } */
    
    return _validCache;
}

-(void)setValidCache:(BOOL)validCache{
    _validCache = validCache;
}

- (void)downloadInBackground
{  
    if (!isValid){
        return;
    }
    if (useCache && self.validCache){
        if (delegate){
            [self.delegate dataDidLoad:cachedData];
        }
        return;
    }
    request = [ASIHTTPRequest requestWithURL:self.url];

    if (permanentCache) {
        [request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
        [request setCachePolicy:ASIAskServerIfModifiedWhenStaleCachePolicy|ASIFallbackToCacheIfLoadFailsCachePolicy];
    }
    if (!isDownloading){
        isDownloading = YES;
        [request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
        [request setDelegate:self];
        [request setDidFinishSelector:@selector(requestDone:)];
        [request setDidFailSelector:@selector(requestWentWrong:)];
        [[App instance].requestsQueue addOperation:request]; 
    }
}


- (void)requestDone:(ASIHTTPRequest *)__request
{
    DDLogCInfo(@"[IFRemoteData]Response receaved from url: %@", self.url);
    isDownloading = NO;
    retryCount = 0;
    useCache = NO;
    if (useCache){
        self.cachedData = [__request responseString]; 
        self.validCache = YES;
        if (createdAt) {
            [createdAt release];
        }
        createdAt = [[NSDate alloc] init];
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(dataDidLoad:)]) 
        [self.delegate dataDidLoad:[__request responseString]];
    request = nil;
}

- (void)requestWentWrong:(ASIHTTPRequest *)__request
{
    retryCount++;
    isDownloading = NO;
 //   DLog(@"[IFRemoteData]Error: %@ -> %@", [__request originalURL], [__request error]);
    if (retryCount<kRemoteImageMaxRetryCount){
//        DLog(@"[IFRemoteData]Retrying: %@", self.url);
        [self downloadInBackground];
    }else if(self.delegate){
  //      request = nil;
        [self.delegate dataDidLoad:NULL];
    }
}



-(void)clearCache{
    if (_validCache && !permanentCache && [cachedData retainCount]<2){
    //    DLog(@"[IFRemoteData] clear cahe");
        _validCache = NO;
        self.cachedData = nil;
    }
}


                     
- (void)dealloc
{
    if (request && isDownloading) {
       [request clearDelegatesAndCancel];
    }
    if (createdAt) {
        [createdAt release];
    }
    [self clearCache];
    self.cachedData = nil;
    self.key = nil;
    [url release];
    [super dealloc];
}


@end
